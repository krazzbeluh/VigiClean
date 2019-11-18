//
//  UserAccount.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import Firebase

class UserAccount {
    enum UAccountError: Error {
        case emptyTextField, notMatchingPassword, userDocumentNotCreated
    }
    
    static var isConnected: Bool {
        return Auth.auth().currentUser != nil
    }
    
    static var isConnectedWithEmail: Bool {
        return Auth.auth().currentUser?.email != nil
    }
    
    static func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        Auth.auth().createUser(
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
        Auth.auth().signIn(
            withEmail: email,
            password: password) { (authResult, error) in
                guard error == nil,
                    let user = authResult?.user else {
                        completion(error)
                        return
                }
                
                createUserDocument(for: user, named: email, merge: true) { error in
                    print(error ?? "An unknown error occured while creating user document in method signIn(email:password:completion:") // swiftlint:disable:this line_length
                }
                
                completion(nil)
        }
    }
    
    static func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        Auth.auth().signInAnonymously { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            completion(error)
        }
    }
    
    static func signOut(completion: (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
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
        let docRef = database.collection("User").document(uid)
        docRef.getDocument { (document, error) in
            guard let document = document else {
                //TODO : Display error
                return
            }
            
            if document.exists {
                //TODO: Display error (if necessary)
                completion(nil)
            } else {
                docRef.setData(
                    ["credits": 0,
                     "lastName": NSNull(),
                     "firstName": NSNull(),
                     "username": named ?? uid],
                    merge: merge) { error in // creating user's document
                        completion(error)
                }
            }
        }
        
        completion(nil)
    }
}
