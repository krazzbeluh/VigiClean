//
//  AuthFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthFake: Auth {
    let error: Error?
    let result: AuthDataResult?
    
    init(error: Error?, result: AuthDataResult?) {
        self.error = error
        self.result = result
    }
    
    override func signInAnonymously(completion: AuthDataResultCallback? = nil) {
        completion!(result, error)
    }
    
    override func createUser(withEmail email: String, password: String, completion: AuthDataResultCallback? = nil) {
        completion!(result, error)
    }
    
    override func signIn(withEmail email: String, password: String, completion: AuthDataResultCallback? = nil) {
        completion!(result, error)
    }
    
    override func signOut() throws {
        guard let error = error else {
            return
        }
        
        throw error
    }
    
    private var user: User?
    override var currentUser: User? {
        get {
            return user
        }
        set {
            self.user = newValue
        }
    }
}
