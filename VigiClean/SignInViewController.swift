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
    
}

class SignInViewController: UIViewController, SignInView {
    // MARK: Properties
    var presenter: SignInViewPresenter!
    var isInscription = true
    
    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var performButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SignInPresenter(view: self)
        performButton.setTitle(isInscription ? "Inscription" : "Connexion", for: .normal)
        
        if #available(iOS 13, *) {
            dismissButton.isHidden = true
        }
    }
    
    // MARK: Actions
    @IBAction func didTapPerformButton(_ sender: Any) {
        performButton.isHidden = true
        connection()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyBoard(_ sender: Any) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    // MARK: Methods
    
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
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
