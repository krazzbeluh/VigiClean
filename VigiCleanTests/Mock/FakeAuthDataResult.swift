//
//  FakeAuthDataResult.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 28/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

class FakeAuthDataResult: AuthDataResult {
    
    private var resultedUser: User
    override var user: User {
        get {
            return resultedUser
        }
        
        set {
            resultedUser = newValue
        }
    }
    
    init(user: User) {
        self.resultedUser = user
    }
}
