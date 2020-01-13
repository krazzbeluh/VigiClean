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

class FakeDashboardView: DashboardView {
    var listener: (() -> Void)?
    
    init() {}
    
    init(listener: @escaping (() -> Void)) {
        self.listener = listener
    }
    
    var didCallSetAvatar = false
    var didCallSendAlert = false
    var didCallSetAvatarToImage = false
    var didCallSalesGotten = false
    
    func setAvatar() {
        didCallSetAvatar = true
        listener?()
    }
    
    func setAvatar(to image: Data) {
        didCallSetAvatarToImage = true
        listener?()
    }
    
    func salesGotten() {
        didCallSalesGotten = true
        listener?()
    }
    
    func displayError(message: String) {
        didCallSendAlert = true
        listener?()
    }
    
    func displayError(message: String, completion: (() -> Void)?) {
        displayError(message: message)
    }
}
