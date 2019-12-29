//
//  FakeDashboardView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 25/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import UIKit
@testable import VigiClean

class FakeDashboardView: UIViewController, DashboardView {
    var didCallSetAvatar = false
    var didCallSendAlert = false
    
    func setAvatar(with image: Data) {
        didCallSetAvatar = true
    }
    
    func sendAlert(message: String) {
        didCallSendAlert = true
    }
}
