//
//  UserFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 04/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
@testable import VigiClean

class UserFake: User {
    
    var id: String
    override var uid: String {
        get {
            return id
        }
        
        set {
            id = newValue
        }
    }
    
    init(uid: String) {
        self.id = uid
    }
}
