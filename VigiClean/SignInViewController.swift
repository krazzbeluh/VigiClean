//
//  ConnectionViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol SharedAccountingMethodsView: class {
    var activityIndicator: UIActivityIndicatorView! { get set }
    func showAlert(with type: Error)
    func performSegue()
    func switchActivityIndicator(hidden: Bool)
}

protocol SignInView: SharedAccountingMethodsView {
}

class SignInViewController: UIViewController, SignInView {
    // MARK: Properties
    var presenter: SignInViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignInPresenter(view: self)
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        }
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        signIn()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: Methods
    
    func signIn() {
        presenter.signIn(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
    
    func switchActivityIndicator(hidden: Bool) {
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField != emailTextField {
            textField.resignFirstResponder()
            signIn()
        } else {
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
}
