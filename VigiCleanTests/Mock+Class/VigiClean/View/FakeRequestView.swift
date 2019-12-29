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
    
    func configure(with object: Object) {}
    
//    func requestSent() {
//        let name = Notification.Name("RequestSent")
//        let notification = Notification(name: name)
//        NotificationCenter.default.post(notification)
//    }
    
    func configureMap(with location: Poi) {
        self.location = location
    }
}
