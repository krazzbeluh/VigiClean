//
//  DashboardViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController, DashboardView {
    // MARK: Outlets
    @IBOutlet weak var scoreView: ScoreView!
    
    var presenter: DashboardViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(view: self)
    }

    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) {}
}
