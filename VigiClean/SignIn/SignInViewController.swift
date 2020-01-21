//
//  ConnectionViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// manages signIn with form
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
    
    func signIn() { // calls sign in from presenter
        presenter.signIn(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func userSignedIn() { // performs segue on presenter response
        switchActivityIndicator(hidden: true)
        performSegue(withIdentifier: SegueType.dashboard.rawValue, sender: nil)
    }
    
    func switchActivityIndicator(hidden: Bool) { // manages activityIndicator display
        activityIndicator.isHidden = hidden
        performButton.isHidden = !hidden
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}

extension SignInViewController: UITextFieldDelegate { // manages textFields
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
