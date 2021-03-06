//
//  FakeScannerView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 30/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeScannerView: ScannerView {
    var isAlreadyPresentingAlert: Bool {
        return true
    }
    
    var correctCodeFoundWasCalledXTimes = 0
    var didCallInvalidCodeFound = false
    var didCallValidObjectFound = false
    var didCallDisplayError = false
    
    func correctCodeFound() {
        correctCodeFoundWasCalledXTimes += 1
    }
    
    func displayLoadViews(_ statement: Bool) {
        
    }
    
    func validObjectFound() {
        didCallValidObjectFound = true
    }
    
    func invalidCodeFound(error: Error) {
        didCallInvalidCodeFound = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }

}
