//
//  UserAccount.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserAccount {
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated
    }
    
    static var currentUser: User? {
        return FirebaseInterface.auth.currentUser
    }
    
    static var isConnected: Bool {
        currentUser != nil
    }
    
    static var isConnectedWithEmail: Bool {
        currentUser?.email != nil
    }
    
    static func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        FirebaseInterface.auth.createUser(
            withEmail: email,
            password: password) { (authResult, error) in
                
                guard error == nil,
                    let user = authResult?.user else { // if no error, user is created
                        completion(error)
                        return
                }
                
                createUserDocument(for: user, named: username) { error in
                    completion(error)
                }
                
                completion(nil)
                return
        }
    }
    
    static func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        FirebaseInterface.auth.signIn(
            withEmail: email,
            password: password) { (_, error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                completion(nil)
        }
    }
    
    static func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        FirebaseInterface.auth.signInAnonymously { (_, error) in
            completion(error)
        }
    }
    
    static func attachEmail(email: String,
                            password: String,
                            completion: @escaping ((Error?) -> Void)) {
        currentUser?.updateEmail(to: email) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            currentUser?.updatePassword(to: password) { (error) in
                guard error == nil else {
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    static func signOut(completion: (Error?) -> Void) {
        do {
            try FirebaseInterface.auth.signOut()
        } catch let error {
            completion(error)
        }
        completion(nil)
    }
    
    static func convertError(_ error: Error) -> AuthErrorCode? {
        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            return nil
        }
        
        return errCode
    }
    
    private static func createUserDocument(for user: User,
                                           named: String,
                                           completion: @escaping (Error?) -> Void) {
        let uid = user.uid // getting uid to create user's document
        FirebaseInterface.database.collection("User").document(uid).setData(
            ["credits": 0,
             "username": named]) { error in
                completion(error)
        }
    }
    
}
