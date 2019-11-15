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
        case emptyTextField, notMatchingPassword
    }
    
    static func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            
            guard error == nil else {
                completion(error)
                return
            }
            
            guard let user = Auth.auth().currentUser else {
                print("Error 0")
                return
            }
            
            let db = Firestore.firestore()
            let documentName = user.uid
            db.collection("User").document(documentName).setData(["credits": 0, "lastName": NSNull(), "firstName": NSNull(), "username": username]) { error in
                guard error == nil else {
                    print(error ?? "Erreur")
                    return
                }
                print("Document successfully created (named: \(documentName))")
            }
            
            completion(nil)
            return
        }
    }
    
    static func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            completion(error)
        }
    }
    
    static func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        Auth.auth().signInAnonymously { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            completion(error)
        }
    }
    
    static func checkConnection() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    static func convertError(_ error: Error) -> AuthErrorCode? {
        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            return nil
        }
        
        return errCode
    }
}
