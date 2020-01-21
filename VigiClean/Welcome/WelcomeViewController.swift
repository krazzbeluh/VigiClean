//
//  WelcomeViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// Welcome asks authentication method
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
    @IBAction func didTapAnonymousButton(_ sender: Any) { // Signs the user in and launchs app
        switchActivityIndicator(hidden: false)
        presenter.signIn()
    }
    
    // MARK: Methods
    func performSegue() { // launch dashboard
        switchActivityIndicator(hidden: true)
        performSegue(withIdentifier: SegueType.dashboard.rawValue, sender: nil)
    }
    
    func switchActivityIndicator(hidden: Bool) { // Manages activity indicator
        activityIndicator.isHidden = hidden
        anonymousButton.isHidden = !hidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Manages display settings for dashboard
        guard segue.identifier == SegueType.dashboard.rawValue else {
            return
        }
        
        segue.destination.modalPresentationStyle = .fullScreen
    }
}
