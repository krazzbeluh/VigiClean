//
//  UIViewController + Extension.swift
//  VigiClean
//
//  Created by Paul Leclerc on 21/09/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//
import Foundation
import UIKit

// Every view's parent class
protocol BaseView: class {
    func displayError(message: String)
    func displayError(message: String, completion: (() -> Void)?)
}

// Adds default methods for BaseView in ViewControllers
extension UIViewController: BaseView {
    func displayError(message: String) { // sends alert
        displayError(message: message, completion: nil)
    }
    
    func displayError(message: String, completion: (() -> Void)?) { // sends alert
        let alertVC = UIAlertController(title: AlertStrings.error.rawValue, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .cancel, handler: { (_) in
            guard let completion = completion else {
                return
            }
            completion()
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
}

// Segue's reusable identifiers. Prevents from hardcoded Strings
enum SegueType: String {
    case welcome = "segueToWelcome"
    case dashboard = "segueToDashboard"
    case marketplace = "segueToMarketplace"
    case congrats = "segueToCongrats"
    case request = "segueToRequest"
    case launchUnwind = "unwindToLaunch"
    case dashboardUnwind = "unwindToDashboard"
}

enum CellType: String {
    case attachEmail = "AttachEmailCell"
    case disconnect = "DisconnectCell"
    case changeAvatar = "changeAvatarCell"
    case changeUsername = "changeUsernameCell"
    case changeEmail = "changeEmailCell"
    case changePassword = "ChangePasswordCell"
    case object = "ObjectCell"
    case marketPlace = "MarketplaceCell"
    case saleCell = "SaleCell"
}
