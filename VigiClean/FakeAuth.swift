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
    
    private var user: User?
    override var currentUser: User? {
        get {
            return user
        }
        
        set {
            user = newValue
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
        user = FakeUser(mail: email, identifier: email ?? "anonymous")
    }
    
    override func signInAnonymously(completion: AuthDataResultCallback? = nil) {
        signIn(email: nil)
        completion!(result, error)
    }
    
    override func createUser(withEmail email: String, password: String, completion: AuthDataResultCallback? = nil) {
        signIn(email: email)
        
        FakeServer.users.append(FakeUser(mail: email, identifier: email))
        completion!(result, error)
    }
}
