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
    
    var id: String
    override var uid: String {
        get {
            return id
        }
        
        set {
            id = newValue
        }
    }
    
    init(mail: String?, id: String) {
        self.mail = mail
        self.id = id
    }
}
