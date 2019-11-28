//
//  FakeAuth.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 28/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

class FakeAuth: Auth {
    let result: AuthDataResult?
    let error: Error?
    
    var isConnected = false
    var user: User?
    override var currentUser: User? {
        get {
            if isConnected {
                return user
            } else {
                return nil
            }
        }
    }
    var currentFakeUser: FakeUser? {
        return currentUser as? FakeUser
    }
    
    init(result: AuthDataResult?, error: Error?) {
        self.result = result
        self.error = error
    }
    
    func signIn(email: String?) {
        isConnected = true
        user = FakeUser(mail: email, id: email ?? "anonymous")
    }
    
    override func signInAnonymously(completion: AuthDataResultCallback? = nil) {
        signIn(email: nil)
        completion!(result, error)
    }
    
    override func createUser(withEmail email: String, password: String, completion: AuthDataResultCallback? = nil) {
        signIn(email: email)
        
        FakeServer.users.append(FakeUser(mail: email, id: email))
        completion!(result, error)
    }
}
