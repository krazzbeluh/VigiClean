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
    // MARK: Properties
    var presenter: ChooseAccountingMethodViewPresenter!
    
    // MARK: Outlets
    @IBOutlet weak var anonymousButton: UIButton!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ChooseAccountingMethodPresenter(view: self)
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
