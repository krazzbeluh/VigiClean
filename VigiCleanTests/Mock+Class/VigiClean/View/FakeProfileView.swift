//
//  FakeProfileView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeProfileView: ProfileView {
    var didCallUserSignedOut = false
    var didCallDisplayUsername = false
    var didCallDisplayEmail = false
    var didCallDisplayError = false
    var didCallDisplayAvatar = false
    var didCallPasswordChanged = false
    
    func userSignedOut() {
        didCallUserSignedOut = true
    }
    
    func display(username: String) {
        didCallDisplayUsername = true
    }
    
    func display(email: String) {
        didCallDisplayEmail = true
    }
    
    func display(avatar: Data) {
        didCallDisplayAvatar = true
    }
    
    func passwordChanged() {
        didCallPasswordChanged = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }

}
