//
//  ChooseAccountingMethodViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class ChooseAccountingMethodViewController: UIViewController {
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func buttonToConnectionVC(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToLogIn", sender: sender)
    }
    
    // MARK: Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToLogIn" else {
            return
        }
        
        guard let successVC = segue.destination as? SignInViewController else {
            return
        }
        
        guard let sender = sender as? UIButton else {
            return
        }
        
        successVC.isInscription = sender.titleLabel?.text == "Se connecter" ? false : true
    }
}
