//
//  UIViewController + Extension.swift
//  VigiClean
//
//  Created by Paul Leclerc on 21/09/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//
import Foundation
import UIKit

protocol BaseView: class {
    func displayError(message: String)
}

extension UIViewController: BaseView {
    func displayError(message: String) { // sends alert
        let alertVC = UIAlertController(title: AlertStrings.error.rawValue, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: AlertStrings.ok.rawValue, style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController: UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { //swiftlint:disable:this line_length
        
        completionHandler([.alert, .badge, .sound])
    }
    
    // For handling tap and user actions
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
}

enum SegueType: String {
    case welcome = "segueToWelcome"
    case dashboard = "segueToDashboard"
    case marketplace = "segueToMarketPlace"
    case congrats = "segueToCongrats"
    case request = "segueToRequest"
    case launchUnwind = "unwindToLaunch"
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
}
