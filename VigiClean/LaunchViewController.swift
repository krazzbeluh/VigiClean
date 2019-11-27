//
//  LaunchViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 20/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserAccount.isConnected {
            performSegue(withIdentifier: "segueToDashboard", sender: nil)
        } else {
            performSegue(withIdentifier: "segueToWelcome", sender: nil)
        }
    }

    @IBAction func unwindToLaunch(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }

}