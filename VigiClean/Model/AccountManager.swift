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
    //    static var shared = AccountManager()
    
    init() {
        self.auth = Auth.auth()
        self.database = Firestore.firestore()
        self.storage = Storage.storage()
    }
    
    init(auth: Auth, database: Firestore) {
        self.auth = auth
        self.database = database
        self.storage = Storage.storage()
    }
    
    private var auth: Auth
    private var database: Firestore
    private var storage: Storage
    private var avatar: Data?
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated, unknownUID, noCreditsFound, userNotLoggedIn
    }
    
    static var currentUser = VigiCleanUser(username: nil)
    
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
            AccountManager.currentUser.user?.updatePassword(to: password) { (error) in
                guard error == nil else {
                    let errCode = ErrorHandler().convertToAuthError(error!)
                    completion(errCode)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func updatePseudo(to newPseudo: String, with password: String, completion: @escaping (Error?) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid,
            let email = AccountManager.currentUser.user?.email else {
                completion(UAccountError.userNotLoggedIn)
                return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        AccountManager.currentUser.user?.reauthenticate(with: credential, completion: { (_, error) in
            if let error = error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
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
        })
    }
    
    func updateEmail(to newEmail: String, with password: String, completion: @escaping (Error?) -> Void) {
        guard let email = AccountManager.currentUser.user?.email else {
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        AccountManager.currentUser.user?.reauthenticate(with: credential, completion: { (_, error) in
            if let error = error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
            AccountManager.currentUser.user?.updateEmail(to: newEmail, completion: { (error) in
                if let error = error {
                    let errCode = ErrorHandler().convertToAuthError(error)
                    completion(errCode)
                    return
                }
                completion(nil)
            })
        })
    }
    
    func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
        } catch let error {
            let errCode = ErrorHandler().convertToAuthError(error)
            completion(errCode)
            return
        }
        completion(nil)
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
        database.collection("User").document(AccountManager.currentUser.user?.uid ?? "")
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    guard let user = AccountManager.currentUser.user else {
                        return
                    }
                    
                    self.createUserDocument(for: user.uid, named: nil) { (error) in
                        print("Error : \(String(describing: error))")
                    }
                    return
                }
                print("Current data: \(data)")
                
                if let username = data["username"] as? String {
                    AccountManager.currentUser.username = username
                }
                
                if let credits = data["credits"] as? Int {
                    AccountManager.currentUser.credits = credits
                    
                    guard let creditsChanged = creditsChanged else {
                        return
                    }
                    
                    creditsChanged(credits)
                }
                
                if let isEemployee = data["isMaintainer"] as? Bool {
                    AccountManager.currentUser.isEmployee = isEemployee
                }
        }
    }
    
    func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid else {
            callback(.failure(UAccountError.userNotLoggedIn))
            return
        }
        
        database.collection("User").document(uid).getDocument { document, error in
            if let error = error {
                let errCode = ErrorHandler().convertToFirestoreError(error)
                callback(.failure(errCode ?? FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
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
        if let avatar = self.avatar {
            callback(.success(avatar))
        } else {
            guard let uid = AccountManager.currentUser.user?.uid else {
                callback(.failure(UAccountError.userNotLoggedIn))
                return
            }
            
            let imageReference = storage.reference(withPath: "images/\(uid).jpeg")
            print(imageReference.fullPath)
            
            imageReference.getData(maxSize: 60 * 1024 * 1024) { data, error in
                guard let data = data,
                    error == nil else {
                        let errCode = ErrorHandler().convertToStorageError(error!)
                        callback(.failure(errCode ?? FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                        return
                }
                
                callback(.success(data))
            }
        }
    }
}
