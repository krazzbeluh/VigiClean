//
//  WelcomeViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

protocol WelcomeView: class {
    func performSegue()
    func showAlert(with error: Error)
}

class WelcomeViewController: UIViewController, WelcomeView {
    // MARK: Properties
    var presenter: WelcomeViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var anonymousButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WelcomePresenter(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.performSegueIfUserIsConnected()
    }
    
    // MARK: Actions
    @IBAction func didTapAnonymousButton(_ sender: Any) {
        anonymousButton.isHidden = true
        presenter.signIn()
    }
    
    @IBAction func unwindToWelcome(segue: UIStoryboardSegue) { 
        
    }
    
    // MARK: Methods
    func performSegue() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToDashboard" else {
            return
        }
        
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
