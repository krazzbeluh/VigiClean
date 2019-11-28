//
//  FakeUser.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 28/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

class FakeUser: User {
    static var isConnected = false
    
    var mail: String?
    override var email: String? {
        get {
            return mail
        }
        
        set {
            mail = newValue
        }
    }
    
    init(michel: Bool) {
    }
}
