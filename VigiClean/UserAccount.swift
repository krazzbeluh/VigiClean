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
    static func signUp(email: String, password: String, completion: @escaping ((Result<Void, Error>) -> Void)) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            
            guard error == nil else {
                print(error.debugDescription)
                completion(.failure(error!))
                return
            }
            completion(.success(Void()))
        }
    }
    
    static func signIn(email: String, password: String, completion: @escaping((Result<Void, Error>) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            guard error == nil else {
                print(error.debugDescription)
                completion(.failure(error!))
                return
            }
            completion(.success(Void()))
        }
    }
}
