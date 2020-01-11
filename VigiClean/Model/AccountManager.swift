//
//  AccountManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AccountManager {
    init() {
        self.auth = Auth.auth()
        self.database = Firestore.firestore()
    }
    
    init(auth: Auth, database: Firestore) {
        self.auth = auth
        self.database = database
    }
    
    private var auth: Auth
    private var database: Firestore
    private var storage = Storage.storage()
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated, unknownUID, noCreditsFound, userNotLoggedIn,
        userNotLoggedInWithEmail, notEnoughCredits
    }
    
    static var currentUser = VigiCleanUser(username: nil)
    private static var maxFileSize: Int64 = 5 * 1024 * 1024
    
    var isConnected: Bool {
        AccountManager.currentUser.user != nil
    }
    
    var isConnectedWithEmail: Bool {
        AccountManager.currentUser.user?.email != nil
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.createUser(
            withEmail: email,
            password: password) { (_, error) in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.signIn(
            withEmail: email,
            password: password) { (_, error) in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        auth.signInAnonymously { (_, error) in
            guard let error = error else {
                completion(nil)
                return
            }
            let errCode = ErrorHandler().convertToAuthError(error)
            completion(errCode)
        }
    }
    
    func attachEmail(email: String,
                     password: String,
                     completion: @escaping ((Error?) -> Void)) {
        AccountManager.currentUser.user?.updateEmail(to: email) { (error) in
            guard error == nil else {
                let errCode = ErrorHandler().convertToAuthError(error!)
                completion(errCode)
                return
            }
            completion(nil)
        }
    }
    
    func updatePassword(password: String, completion: @escaping ((Error?) -> Void)) {
        AccountManager.currentUser.user?.updatePassword(to: password) { (error) in
            guard error == nil else {
                let errCode = ErrorHandler().convertToAuthError(error!)
                completion(errCode)
                return
            }
            completion(nil)
        }
    }
    
    func updatePseudo(to newPseudo: String, with password: String, completion: @escaping (Error?) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid else {
            completion(UAccountError.userNotLoggedIn)
            return
        }
        
        reauthenticate(password: password) { (error) in
            if let error = error {
                completion(error)
            } else {
                self.database.collection("User").document(uid).updateData([
                    "username": newPseudo
                ]) { error in
                    if let error = error {
                        let errCode = ErrorHandler().convertToFirestoreError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func updateEmail(to newEmail: String, with password: String, completion: @escaping (Error?) -> Void) {
        reauthenticate(password: password) { (error) in
            if let error = error {
                completion(error)
            } else {
                AccountManager.currentUser.user?.updateEmail(to: newEmail, completion: { (error) in
                    if let error = error {
                        let errCode = ErrorHandler().convertToAuthError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                })
            }
        }
    }
    
    func updatePassword(to newPassword: String, from oldPassword: String, completion: @escaping (Error?) -> Void) {
        reauthenticate(password: oldPassword) { (error) in
            if let error = error {
                completion(error)
            } else {
                AccountManager.currentUser.user?.updatePassword(to: newPassword) { (error) in
                    if let error = error {
                        let errCode = ErrorHandler().convertToAuthError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        if !isConnectedWithEmail {
            AccountManager.currentUser.user?.delete(completion: { (error) in
                if let error = error {
                    completion(ErrorHandler().convertToAuthError(error))
                } else {
                    completion(nil)
                }
            })
        } else {
            do {
                try auth.signOut()
            } catch let error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
            AccountManager.currentUser.avatar = nil
            completion(nil)
        }
    }
    
    func createUserDocument(for user: String,
                            named: String?,
                            completion: @escaping (Error?) -> Void) {
        
        database.collection("User").document(user).setData(
            ["credits": 0,
             "username": named ?? NSNull()]) { error in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func listenForUserDocumentChanges(creditsChanged: ((Int) -> Void)?) {
        guard let user = AccountManager.currentUser.user else {
            return
        }
        
        database.collection("User").document(user.uid)
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                
                guard let data = document.data() else {
                    print("Document data was empty.")
                    
                    self.createUserDocument(for: user.uid, named: nil) { (error) in
                        print("Error : \(String(describing: error))")
                    }
                    return
                }
                print("Current data: \(data)")
                
                guard let creditsChanged = creditsChanged else {
                    return
                }
                
                let credits: Int
                do {
                    credits = try self.getUserInfos(in: data)
                } catch {
                    print("no credits in data")
                    return
                }
                
                creditsChanged(credits)
        }
    }
    
    func getUserInfos(in data: [String: Any]) throws -> Int {
        if let username = data["username"] as? String {
            AccountManager.currentUser.username = username
        }
        
        if let employedAt = data["employedAt"] as? String {
            AccountManager.currentUser.employedAt = employedAt
        }
        
        guard let credits = data["credits"] as? Int else {
            throw FirebaseInterface.FIRInterfaceError.documentDoesNotExists
        }
        
        AccountManager.currentUser.credits = credits
        
        return credits
    }
    
    func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid else {
            callback(.failure(UAccountError.userNotLoggedIn))
            return
        }
        
        database.collection("User").document(uid).getDocument { document, error in
            if let error = error {
                let errCode = ErrorHandler().convertToFirestoreError(error)
                callback(.failure(errCode!))
            }
            
            guard let document = document, document.exists else {
                callback(.failure(FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                return
            }
            
            guard let data = document.data(),
                let role = data["isMaintainer"] as? Bool else {
                    callback(.failure(FirebaseInterface.FIRInterfaceError.unableToDecodeData))
                    return
            }
            
            callback(.success(role))
        }
    }
    
    func getAvatar(callback: @escaping ((Result<Data, Error>) -> Void)) {
        if let avatar = AccountManager.currentUser.avatar {
            callback(.success(avatar))
        } else {
            guard let uid = AccountManager.currentUser.user?.uid else {
                callback(.failure(UAccountError.userNotLoggedIn))
                return
            }
            
            let imageReference = storage.reference(withPath: "images/\(uid).jpg")
            print(imageReference.fullPath)
            
            imageReference.getData(maxSize: AccountManager.maxFileSize) { data, error in
                guard let data = data,
                    error == nil else {
                        let errCode = ErrorHandler().convertToStorageError(error!)
                        callback(.failure(errCode ?? FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                        return
                }
                
                AccountManager.currentUser.avatar = data
                callback(.success(data))
            }
        }
    }
    
    func updateAvatar(from avatar: Data, with password: String, callback: @escaping ((Result<Data, Error>) -> Void)) {
        guard let uid = AccountManager.currentUser.user?.uid,
            AccountManager.currentUser.user?.email != nil else {
                callback(.failure(UAccountError.userNotLoggedInWithEmail))
                return
        }
        
        reauthenticate(password: password) { (error) in
            if let error = error {
                callback(.failure(error))
            } else {
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("images/\(uid).jpg")
                
                imageRef.putData(avatar, metadata: nil) { (_, error) in
                    if let error = error {
                        callback(.failure(ErrorHandler().convertToStorageError(error)))
                    }
                    
                    AccountManager.currentUser.avatar = avatar
                    callback(.success(avatar))
                }
            }
        }
    }
    
    private func reauthenticate(password: String, completion: @escaping (Error?) -> Void) {
        guard let email = AccountManager.currentUser.user?.email else {
            completion(UAccountError.userNotLoggedIn)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        AccountManager.currentUser.user?.reauthenticate(with: credential) { (_, error) in
            if let error = error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
            completion(nil)
        }
    }
}
