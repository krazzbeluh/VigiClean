//
//  ConnectionViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit
import Firebase

class ConnectionViewController: UIViewController {
    // MARK: Properties
    private let presenter = ConnectionViewPresenter()
    private var isInscription = true
    
    // MARK: Outlets
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var performButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pseudoTextField.isHidden = isInscription ? false : true
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        if isInscription {
            inscription()
        } else {
            connection()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Methods
    func inscription() {
        presenter.inscription(email: emailTextField.text, password: passwordTextField.text)
    }
    
    func connection() {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!) { (authResult, error) in // swiftlint:disable:this unused_closure_parameter line_length
            if error != nil {
                print(error.debugDescription)
            } else {
                print("Welcome back \(self.emailTextField.text!) ✅")
            }
        }
    }
}
