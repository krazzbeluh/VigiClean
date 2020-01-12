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
        case notMatchingPassword, userDocumentNotCreated, userNotLoggedIn,
        userNotLoggedInWithEmail, notEnoughCredits
    }
    
    private static var maxFileSize: Int64 = 5 * 1024 * 1024
    
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
        guard let user = VigiCleanUser.currentUser.user else {
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
            VigiCleanUser.currentUser.username = username
        }
        
        if let employedAt = data["employedAt"] as? String {
            VigiCleanUser.currentUser.employedAt = employedAt
        }
        
        guard let credits = data["credits"] as? Int else {
            throw FirebaseInterfaceError.documentDoesNotExists
        }
        
        VigiCleanUser.currentUser.credits = credits
        
        return credits
    }
    
    func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = VigiCleanUser.currentUser.user?.uid else {
            callback(.failure(UAccountError.userNotLoggedIn))
            return
        }
        
        database.collection("User").document(uid).getDocument { document, error in
            if let error = error {
                let errCode = ErrorHandler().convertToFirestoreError(error)
                callback(.failure(errCode!))
            }
            
            guard let document = document, document.exists else {
                callback(.failure(FirebaseInterfaceError.documentDoesNotExists))
                return
            }
            
            guard let data = document.data(),
                let role = data["isMaintainer"] as? Bool else {
                    callback(.failure(FirebaseInterfaceError.unableToDecodeData))
                    return
            }
            
            callback(.success(role))
        }
    }
    
    func getAvatar(callback: @escaping ((Result<Data, Error>) -> Void)) {
        if let avatar = VigiCleanUser.currentUser.avatar {
            callback(.success(avatar))
        } else {
            guard let uid = VigiCleanUser.currentUser.user?.uid else {
                callback(.failure(UAccountError.userNotLoggedIn))
                return
            }
            
            let imageReference = storage.reference(withPath: "images/\(uid).jpg")
            print(imageReference.fullPath)
            
            imageReference.getData(maxSize: AccountManager.maxFileSize) { data, error in
                guard let data = data,
                    error == nil else {
                        let errCode = ErrorHandler().convertToStorageError(error!)
                        callback(.failure(errCode ?? FirebaseInterfaceError.documentDoesNotExists))
                        return
                }
                
                VigiCleanUser.currentUser.avatar = data
                callback(.success(data))
            }
        }
    }
    
    func updateAvatar(from avatar: Data, with password: String, callback: @escaping ((Result<Data, Error>) -> Void)) {
        guard let uid = VigiCleanUser.currentUser.user?.uid,
            VigiCleanUser.currentUser.user?.email != nil else {
                callback(.failure(UAccountError.userNotLoggedInWithEmail))
                return
        }
        
        VigiCleanUser.currentUser.reauthenticate(password: password) { (error) in
            if let error = error {
                callback(.failure(error))
            } else {
                let storageRef = self.storage.reference()
                let imageRef = storageRef.child("images/\(uid).jpg")
                
                imageRef.putData(avatar, metadata: nil) { (_, error) in
                    if let error = error {
                        callback(.failure(ErrorHandler().convertToStorageError(error)))
                    }
                    
                    VigiCleanUser.currentUser.avatar = avatar
                    callback(.success(avatar))
                }
            }
        }
    }
}
