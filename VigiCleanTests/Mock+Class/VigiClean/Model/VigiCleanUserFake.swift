//
//  VigiCleanUserFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 12/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class VigiCleanUserFake: VigiCleanUser {
    let error: Error?
    
    init(username: String?, error: Error?) {
        self.error = error
        super.init(username: username)
    }
    
    private var isConnectedWithMail = false
    override var isConnectedWithEmail: Bool {
        get {
            return isConnectedWithMail
        }
        set {
            isConnectedWithMail = newValue
        }
    }
    
    override func attachEmail(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func updatePassword(password: String, completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func updatePassword(to newPassword: String,
                                 from oldPassword: String,
                                 completion: @escaping (Error?) -> Void) {
        completion(error)
    }
    
    override func updatePseudo(to newPseudo: String, with password: String, completion: @escaping (Error?) -> Void) {
        completion(error)
    }
    
    override func updateEmail(to newEmail: String, with password: String, completion: @escaping (Error?) -> Void) {
        completion(error)
    }
    
    override func anonymousSignIn(completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func signIn(email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func signUp(username: String, email: String, password: String, completion: @escaping ((Error?) -> Void)) {
        completion(error)
    }
    
    override func signOut(completion: @escaping (Error?) -> Void) {
        completion(error)
    }
}
