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
    var errors: [Error?]?
    
    var id: String // swiftlint:disable:this identifier_name
    override var uid: String {
        get {
            return id
        }
        
        set {
            id = newValue
        }
    }
    
    var mail: String?
    override var email: String? {
        get {
            return mail
        }
        set {
            mail = newValue
        }
    }
    
    init(uid: String, mail: String? = nil, errors: [Error?]? = nil) {
        self.id = uid
        self.errors = errors
        self.mail = mail
    }
    
    override func updateEmail(to email: String, completion: UserProfileChangeCallback? = nil) {
        guard let completion = completion else {
            return
        }
        
        completion(getNextError())
    }
    
    override func updatePassword(to password: String, completion: UserProfileChangeCallback? = nil) {
        guard let completion = completion else {
            return
        }
        
        completion(getNextError())
    }
    
    override func reauthenticate(with credential: AuthCredential, completion: AuthDataResultCallback? = nil) {
        guard  let completion = completion else {
            return
        }
        
        completion(nil, getNextError())
    }
    
    func getNextError() -> Error? {
        let error = errors?.first ?? nil
        errors?.removeFirst()
        return error
    }
}
