//
//  FakeWelcomeView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeWelcomeView: WelcomeView {
    var didCallPerformSegue = false
    var didCallDisplayError = false
    
    func performSegue() {
        didCallPerformSegue = true
    }
    
    func displayError(message: String) {
        didCallDisplayError  = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }

}
