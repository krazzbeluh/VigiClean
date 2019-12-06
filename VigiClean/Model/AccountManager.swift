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
    
    let auth: Auth
    let database: Firestore
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated
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
                
                completion(nil)
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
                                    named: String,
                                    completion: @escaping (Error?) -> Void) {
        let uid = user.uid // getting uid to create user's document
        database.collection("User").document(uid).setData(
            ["credits": 0,
             "username": named]) { error in
                completion(error)
        }
    }
    
}
