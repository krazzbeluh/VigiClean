//
//  SignUpViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol SignUpView: SharedAccountingMethodsView {
    
}

class SignUpViewController: UIViewController, SignUpView {
    
    // MARK: Properties
    var presenter: SignUpViewPresenter!
    
    // MARK: Outlets
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignUpPresenter(view: self)
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        }
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        signUp()
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {
        for textField in textFields {
            textField.resignFirstResponder()
        }
    }
    
    // MARK: Methods
    func signUp() {
        presenter.signUp(username: textFields[0].text,
                         email: textFields[1].text,
                         password: textFields[2].text,
                         confirmPassword: textFields[3].text)
    }
    
    func switchActivityIndicator(hidden: Bool) {
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
    // MARK: Segues
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
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
