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
    var isInscription = true
    
    // MARK: Outlets
    @IBOutlet weak var pseudoTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var performButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        pseudoTextField.isHidden = isInscription ? false : true
        performButton.setTitle(isInscription ? "Inscription" : "Connexion", for: .normal)
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        performButton.isHidden = true
        if isInscription {
            inscription()
        } else {
            connection()
        }
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        pseudoTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: Methods
    func inscription() {
        presenter.inscription(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success:
                self.performSegue(withIdentifier: "segueToDashboard", sender: nil)
            case .failure(let error):
                self.showAlert(with: error)
            }
            self.performButton.isHidden = false
        }
    }
    
    func connection() {
        presenter.connection(email: emailTextField.text, password: passwordTextField.text) { result in
            switch result {
            case .success:
                self.performSegue(withIdentifier: "segueToDashboard", sender: nil)
            case .failure(let error):
                self.showAlert(with: error)
            }
            self.performButton.isHidden = false
        }
    }
}
