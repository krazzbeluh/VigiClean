//
//  WelcomeViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, WelcomeView {
    // MARK: Properties
    var presenter: WelcomeViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var anonymousButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = WelcomePresenter(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Actions
    @IBAction func didTapAnonymousButton(_ sender: Any) {
        switchActivityIndicator(hidden: false)
        presenter.signIn()
    }
    
    // MARK: Methods
    func performSegue() {
        switchActivityIndicator(hidden: true)
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
    
    func switchActivityIndicator(hidden: Bool) {
        activityIndicator.isHidden = hidden
        anonymousButton.isHidden = !hidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "segueToDashboard" else {
            return
        }
        
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
