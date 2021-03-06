//
//  MarketplaceDelegate.swift
//  VigiClean
//
//  Created by Paul Leclerc on 11/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import UIKit

protocol MarketplaceDelegate: class {  // delegate that allows view and viewCell to communicate
    func present(alert: UIAlertController)
    func displayError(message: String)
}
