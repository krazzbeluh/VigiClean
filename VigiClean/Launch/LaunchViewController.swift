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
            presenter.listenForUserDocumentChanges()
            presenter.getAvatar()
        } else {
            performSegue(withIdentifier: SegueType.welcome.rawValue, sender: nil)
        }
    }
    
    @IBAction func unwindToLaunch(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.modalPresentationStyle = .fullScreen
    }
    
    func allResponseRecieved() {
        performSegue(withIdentifier: SegueType.dashboard.rawValue, sender: nil)
    }
}
