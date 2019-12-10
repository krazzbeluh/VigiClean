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

class AccountManager {
    init() {
        self.auth = Auth.auth()
        self.database = Firestore.firestore()
    }
    
    init(auth: Auth, database: Firestore) {
        self.auth = auth
        self.database = database
    }
    
    var auth: Auth
    var database: Firestore
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated, unknownUID, noCreditsFound
    }
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    var isConnected: Bool {
        currentUser != nil
    }
    
    var isConnectedWithEmail: Bool {
        currentUser?.email != nil
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.createUser(
            withEmail: email,
            password: password) { (authResult, error) in
                
                guard error == nil,
                    let user = authResult?.user else { // if no error, user is created
                        completion(error)
                        return
                }
                
                self.createUserDocument(for: user, named: username) { error in
                    completion(error)
                }
                
                completion(nil)
                return
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.signIn(
            withEmail: email,
            password: password) { (_, error) in
                guard error == nil else {
                    completion(error)
                    return
                }
        }
    }
    
    func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        auth.signInAnonymously { (authResult, error) in
            guard error == nil,
                let result = authResult else {
                    completion(error)
                    return
            }
            
            self.createUserDocument(for: result.user, named: nil) { (error) in
                completion(error)
            }
        }
    }
    
    func attachEmail(email: String,
                     password: String,
                     completion: @escaping ((Error?) -> Void)) {
        currentUser?.updateEmail(to: email) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            self.currentUser?.updatePassword(to: password) { (error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func signOut(completion: (Error?) -> Void) {
        do {
            try auth.signOut()
        } catch let error {
            completion(error)
        }
        completion(nil)
    }
    
    private func createUserDocument(for user: User,
                                    named: String?,
                                    completion: @escaping (Error?) -> Void) {
        let uid = user.uid // getting uid to create user's document
        database.collection("User").document(uid).setData(
            ["credits": 0,
             "username": named ?? NSNull()]) { error in
                completion(error)
        }
    }
    
    func giveCredits(callback: @escaping (Error?) -> Void) {
        guard let uid = currentUser?.uid else {
            callback(UAccountError.unknownUID)
            return
        }
        
        database.collection("User").document(uid).updateData(["credits": FieldValue.increment(Int64(5))]) { (error) in
            callback(error)
        }
    }
    
    func listenForUserCreditsChanges(onChange userCreditsChanged: @escaping (Int) -> Void) {
        database.collection("User").document(currentUser?.uid ?? "")
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                
                guard let credits = data["credits"] as? Int else {
                    print("Error : unable to decode data")
                    return
                }
                
                userCreditsChanged(credits)
        }
    }
    
    func fetchRole(callback: @escaping (Result<Bool, Error>) -> Void) {
        guard let uid = currentUser?.uid else {
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
}
