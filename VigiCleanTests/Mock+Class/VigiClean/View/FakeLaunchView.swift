//
//  FakeLaunchView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 14/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeLaunchView: LaunchView {
    var recievedAllResponses = false
    var didCallDisplayError = false
    
    func allResponseRecieved() {
        recievedAllResponses = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
        completion?()
    }
}
