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
