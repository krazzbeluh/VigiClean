//
//  AccountManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

// AccountManager manages firestore and storage parts of an account. Auth is managed in VigiCleanUser
class AccountManager {
    init(database: Firestore? = nil, storage: Storage? = nil) {
        self.database = database ?? Firestore.firestore()
        self.storage = storage ?? Storage.storage()
    }
    
    private var database: Firestore
    private var storage: Storage
    
    enum UAccountError: Error { // Error Cases
        case notMatchingPassword, userDocumentNotCreated, userNotLoggedIn,
        userNotLoggedInWithEmail, notEnoughCredits
    }
    
    private static var maxFileSize: Int64 = 5 * 1024 * 1024
    
    func createUserDocument(for user: String,
                            named: String?,
                            completion: @escaping (Error?) -> Void) { // Creates user document in database. Stores credits, username
        
        database.collection(FirestoreCollection.user.rawValue).document(user).setData(
            [FirestoreCollection.FirestoreField.credits.rawValue: 0,
             FirestoreCollection.FirestoreField.username.rawValue: named ?? NSNull()]) { error in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func listenForUserDocumentChanges(callback: @escaping (() -> Void)) { // Firestore listener. Manages realtime datas
        guard let user = VigiCleanUser.currentUser.user else {
            return
        }
        
        database.collection(FirestoreCollection.user.rawValue).document(user.uid)
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
                
                self.getUserInfos(in: data)
                
                callback()
        }
    }
    
    func getUserInfos(in data: [String: Any]) {  // Gets userInfos in currentUser which is realtime updated by listenForUserDocumentChanges
        if let username = data[FirestoreCollection.FirestoreField.username.rawValue] as? String {
            VigiCleanUser.currentUser.username = username
        }
        
        if let employedAt = data[FirestoreCollection.FirestoreField.employedAt.rawValue] as? String {
            VigiCleanUser.currentUser.employedAt = employedAt
        }
        
        if let credits = data[FirestoreCollection.FirestoreField.credits.rawValue] as? Int {
            VigiCleanUser.currentUser.credits = credits
        }
    }
    
    func getAvatar(callback: @escaping ((Error?) -> Void)) { // gets user avatar in storage
        if VigiCleanUser.currentUser.avatar != nil {
            callback(nil)
        } else {
            guard let uid = VigiCleanUser.currentUser.user?.uid else {
                callback(UAccountError.userNotLoggedIn)
                return
            }
            
            let imageReference = storage.reference(withPath: "images/\(uid).jpg")
            print(imageReference.fullPath)
            
            imageReference.getData(maxSize: AccountManager.maxFileSize) { data, error in
                guard let data = data,
                    error == nil else {
                        let errCode = ErrorHandler().convertToStorageError(error!)
                        callback(errCode ?? FirebaseInterfaceError.documentDoesNotExists)
                        return
                }
                
                VigiCleanUser.currentUser.avatar = data
                callback(nil)
            }
        }
    }
    
    func updateAvatar(from avatar: Data, with password: String, callback: @escaping ((Result<Data, Error>) -> Void)) { // Sets avatar in storage
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
