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
    override var currentUser: User? {
        get {
            if FakeUser.isConnected {
                return FakeUser(michel: true)
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
    
    override func signInAnonymously(completion: AuthDataResultCallback? = nil) {
        FakeUser.isConnected = true
        currentFakeUser?.email = nil
        completion!(result, error)
    }
}
