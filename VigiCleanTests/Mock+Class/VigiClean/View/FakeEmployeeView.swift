//
//  FakeEmployeeView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeEmployeeView: EmployeeView {
    var didCallReloadTableView = false
    var didCallDisplayError = false
    
    func reloadTableView() {
        didCallReloadTableView = true
    }
    
    func displayError(message: String) {
        didCallDisplayError = true
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
        completion?()
    }
}
