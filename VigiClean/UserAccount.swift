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
    static var auth = Auth.auth()
    
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated
    }
    
    static var isConnected: Bool {
        return auth.currentUser != nil
    }
    
    static var isConnectedWithEmail: Bool {
        return auth.currentUser?.email != nil
    }
    
    static func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.createUser(
            withEmail: email,
            password: password) { (authResult, error) in
                
                guard error == nil,
                    let user = authResult?.user else { // if no error, user is created
                        completion(error)
                        return
                }
                
                createUserDocument(for: user, named: username, merge: true) { error in
                    completion(error)
                }
                
                completion(nil)
                return
        }
    }
    
    static func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.signIn(
            withEmail: email,
            password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter
                guard error == nil else {
                    completion(error)
                    return
                }
                
                completion(nil)
        }
    }
    
    static func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        auth.signInAnonymously { (authResult, error) in // swiftlint:disable:this unused_closure_parameter
            completion(error)
        }
        
        completion(nil)
    }
    
    static func attachEmail(email: String,
                            password: String,
                            completion: @escaping ((Error?) -> Void)) {
        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
            guard error == nil else {
                completion(error)
                return
            }
            Auth.auth().currentUser?.updatePassword(to: password) { (error) in
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
            try auth.signOut()
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
                                           named: String?,
                                           merge: Bool,
                                           completion: @escaping (Error?) -> Void) {
        let database = Firestore.firestore()
        let uid = user.uid // getting uid to create user's document
        database.collection("User").document(uid).setData(
            ["credits": 0,
             "lastName": NSNull(),
             "firstName": NSNull(),
             "username": named ?? uid]) { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                
                completion(nil)
        }
        
        completion(nil)
    }
    
}
