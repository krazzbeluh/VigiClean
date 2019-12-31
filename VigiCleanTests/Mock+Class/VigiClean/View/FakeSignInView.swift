//
//  FakeSignInView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeSignInView: SignInView {
    var didCallUserSignedIn = false
    var didCallSwitchActivityIndicator = false
    var didCallDisplayError = false
    
    func userSignedIn() {
        didCallUserSignedIn = true
    }
    
    func switchActivityIndicator(hidden: Bool) {
        didCallSwitchActivityIndicator = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
}
