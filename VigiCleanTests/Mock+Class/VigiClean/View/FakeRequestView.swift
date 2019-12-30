//
//  FakeRequestView.swift
//  
//
//  Created by Paul Leclerc on 26/12/2019.
//

import UIKit
@testable import VigiClean

class FakeRequestView: UIViewController, RequestView {
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
    
    func requestSent() {
        didCallRequestSent = true
    }
    
    func sendAlert(message: String) {
        alert = message
    }
}
