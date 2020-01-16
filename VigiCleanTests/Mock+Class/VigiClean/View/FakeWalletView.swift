//
//  FakeWalletView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 16/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeWalletView: WalletView {
    var didCallDisplayError = false
    var didCallGottenResponse = false
    
    func gottenResponse() {
        didCallGottenResponse = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
        completion?()
    }
}
