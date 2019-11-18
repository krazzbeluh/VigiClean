//
//  UIViewController + Extension.swift
//  VigiClean
//
//  Created by Paul Leclerc on 21/09/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//
import Foundation
import UIKit

protocol DisplayAlert: UIViewController { // protocol to add method to every UIViewController
    func showAlert(with type: Error)
}

extension UIViewController: DisplayAlert {
    enum UIError: Error { // UIErrors
        case nilInTextField
    }
    
    func showAlert(with error: Error) { // configures alert
        let message: String
        // TODO: Move to presenter
        let authError = UserAccount.convertError(error)
        if authError != nil {
            switch authError {
            case .userNotFound:
                message = "Utilisateur inconnu !"
            default:
                message = "\(error)"
            }
        } else {
            switch error {
            default:
                message = "\(error)"
            }
        }
        
        sendAlert(message: message)
    }
    
    private func sendAlert(message: String) { // sends alert
        let alertVC = UIAlertController(title: "Erreur !", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension UIViewController: UNUserNotificationCenterDelegate {

    //for displaying notification when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) { //swiftlint:disable:this line_length

        //If you don't want to show notification when app is open, do something here else
        //and make a return here.
        //Even you you don't implement this delegate method, you will not see the
        //notification on the specified controller. So, you have to implement this
        //delegate and make sure the below line execute. i.e. completionHandler.

        completionHandler([.alert, .badge, .sound])
    }

    // For handling tap and user actions
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

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
