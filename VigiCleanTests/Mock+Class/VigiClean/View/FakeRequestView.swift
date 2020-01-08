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
    }
    
    func displayError(message: String) {
        alert = message
    }
}
