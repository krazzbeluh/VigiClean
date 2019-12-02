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
    var mail: String?
    override var email: String? {
        get {
            return mail
        }
        
        set {
            mail = newValue
        }
    }
    
    var identifier: String
    override var uid: String {
        get {
            return identifier
        }
        
        set {
            identifier = newValue
        }
    }
    
    init(mail: String?, identifier: String) {
        self.mail = mail
        self.identifier = identifier
    }
}
