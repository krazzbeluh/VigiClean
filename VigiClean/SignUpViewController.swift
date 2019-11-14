//
//  SignUpViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol SignUpView: class {
    func showAlert(with error: Error)
    func performSegue()
}

class SignUpViewController: UIViewController, SignUpView {
    // MARK: Properties
    var presenter: SignUpViewPresenter!
    
    // MARK: Outlets
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        }
    }
    
    // MARK: Methods
    func signUp() {
        performButton.isHidden = true
        presenter.signUp(email: textFields[1].text, password: textFields[2].text)
    }
    
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
}

// MARK: UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField.tag < 3 {
            textFields[textField.tag + 1].becomeFirstResponder()
        } else {
            signUp()
        }
        return true
    }
}
