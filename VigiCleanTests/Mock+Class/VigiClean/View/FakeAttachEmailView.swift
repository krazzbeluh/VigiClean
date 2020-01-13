//
//  FakeAttachEmailView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeAttachEmailView: AttachEmailView {
    var didCallSwitchActivityIndicator = false
    var didCallUpdatedPseudo = false
    var didCallAttachedEmail = false
    var didCallDisplayError = false
    
    func switchActivityIndicator(hidden: Bool) {
        self.didCallSwitchActivityIndicator = true
    }
    
    func updatedPseudo() {
        self.didCallUpdatedPseudo = true
    }
    
    func attachedEmail() {
        self.didCallAttachedEmail = true
    }
    
    func displayError(message: String) {
        self.didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }
}
