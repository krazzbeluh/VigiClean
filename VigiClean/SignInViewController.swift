//
//  ConnectionViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit
import Firebase

protocol SignInView: class {
    func showAlert(with type: Error)
    func performSegue()
}

class SignInViewController: UIViewController, SignInView {
    // MARK: Properties
    var presenter: SignInViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
        performButton.isHidden = true
        presenter.signIn(email: emailTextField.text, password: passwordTextField.text)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: Methods
    
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
