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
    func inscription(email: String, password: String) {
        Auth.auth().createUser(withEmail: email,
                               password: password) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            if error != nil {
                print(error.debugDescription)
            } else {
                print("Welcome \(email) ✅")
            }
        }
    }
}
