//
//  ChooseAccountingMethodViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol ChooseAccountingMethodView: class {
    func performSegue()
    func showAlert(with error: Error)
}

class ChooseAccountingMethodViewController: UIViewController, ChooseAccountingMethodView {
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func didTapAnonymousButton(_ sender: Any) {
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
