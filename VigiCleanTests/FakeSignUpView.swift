//
//  FakeSignUpView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeSignUpView: SignUpView {
    var timesSwitchActivityIndicatorWasCalled = 0
    var didCallUserSignedUp = false
    var didCallDisplayError = false
    
    func switchActivityIndicator(hidden: Bool) {
        timesSwitchActivityIndicatorWasCalled += 1
    }
    
    func userSignedUp() {
        didCallUserSignedUp = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }
}
