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
    static var shared = AccountManager()
    
    private init() {
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
    
    var currentUser = VigiCleanUser(username: nil)
    
    var username, email: String?
    
    var isConnected: Bool {
        currentUser.user != nil
    }
    
    var isConnectedWithEmail: Bool {
        currentUser.user?.email != nil
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.createUser(
            withEmail: email,
            password: password) { (_, error) in
                completion(error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.signIn(
            withEmail: email,
            password: password) { (_, error) in
                completion(error)
        }
    }
    
    func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        auth.signInAnonymously { (_, error) in
            completion(error)
        }
    }
    
    func attachEmail(email: String,
                     password: String,
                     completion: @escaping ((Error?) -> Void)) {
        currentUser.user?.updateEmail(to: email) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            self.currentUser.user?.updatePassword(to: password) { (error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func updatePseudo(to newPseudo: String, completion: @escaping (Error?) -> Void) {
        guard let uid = currentUser.user?.uid else {
            completion(UAccountError.userNotLoggedIn)
            return
        }
        
        database.collection("User").document(uid).updateData([
            "username": newPseudo
        ]) { error in
            completion(error)
        }
    }
    
    func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
        } catch let error {
            completion(error)
            return
        }
        completion(nil)
    }
    
    private func createUserDocument(for user: String,
                                    named: String?,
                                    completion: @escaping (Error?) -> Void) {
        
        database.collection("User").document(user).setData(
            ["credits": 0,
             "username": named ?? NSNull()]) { error in
                completion(error)
        }
    }
    
    func listenForUserDocumentChanges(creditsChanged: ((Int) -> Void)?) {
        database.collection("User").document(currentUser.user?.uid ?? "")
            .addSnapshotListener { (documentSnapshot, error) in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    guard let user = self.currentUser.user else {
                        return
                    }
                    
                    self.createUserDocument(for: user.uid, named: nil) { (error) in
                        print("Error : \(String(describing: error))")
                    }
                    return
                }
                print("Current data: \(data)")
                
                if let username = data["username"] as? String {
                    self.currentUser.username = username
                }
                
                if let credits = data["credits"] as? Int {
                    self.currentUser.credits = credits
                    
                    guard let creditsChanged = creditsChanged else {
                        return
                    }
                    
                    creditsChanged(credits)
                }
                
                if let isEemployee = data["isMaintainer"] as? Bool {
                    self.currentUser.isEmployee = isEemployee
                }
        }
    }
    
    func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = currentUser.user?.uid else {
            callback(.failure(UAccountError.userNotLoggedIn))
            return
        }
        
        database.collection("User").document(uid).getDocument { document, error in
            if let error = error {
                callback(.failure(error))
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
            guard let uid = currentUser.user?.uid else {
                callback(.failure(UAccountError.userNotLoggedIn))
                return
            }
            
            let imageReference = storage.reference(withPath: "images/\(uid).jpeg")
            print(imageReference.fullPath)
            
            imageReference.getData(maxSize: 60 * 1024 * 1024) { data, error in
                guard let data = data,
                    error == nil else {
                        callback(.failure(FirebaseInterface.convertStorageError(error: error!)))
                        return
                }
                
                callback(.success(data))
            }
        }
    }
}
