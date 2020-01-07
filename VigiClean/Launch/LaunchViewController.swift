//
//  LaunchViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 20/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, LaunchView {
    var presenter: LaunchViewPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LaunchPresenter(view: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if presenter.isUserConnected {
            presenter.getAvatar()
        } else {
            performSegue(withIdentifier: "segueToWelcome", sender: nil)
        }
    }
    
    @IBAction func unwindToLaunch(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    func gottenAvatar() {
        performSegue(withIdentifier: "segueToDashboard", sender: nil)
    }
}
