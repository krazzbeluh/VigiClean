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

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
}
