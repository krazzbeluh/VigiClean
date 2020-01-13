//
//  FakeRequestView.swift
//  
//
//  Created by Paul Leclerc on 26/12/2019.
//

import UIKit
@testable import VigiClean

class FakeRequestView: RequestView {
    var location: Poi?
    var alert: String?
    var employeeMode: Bool?
    var didCallRoleFetched = false
    var didCallRequestSent = false
    
    func configure(with object: Object) {}
    
    func configureMap(with location: Poi) {
        self.location = location
    }
    
    func roleFetched() {
        didCallRoleFetched = true
    }
    
    func requestSent(employeeMode: Bool) {
        didCallRequestSent = true
        self.employeeMode = employeeMode
    }
    
    func displayError(message: String) {
        alert = message
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }
}
