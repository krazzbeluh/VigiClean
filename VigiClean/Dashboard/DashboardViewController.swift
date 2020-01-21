//
//  DashboardViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// Dashboard is the app center. It let the user access to marketplace, scanner and account settings
class DashboardViewController: UIViewController, DashboardView {
    // MARK: Outlets
    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var grayOutView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var employeeSpace: UIButton!
    
    var presenter: DashboardViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(view: self)
        
        if presenter.isEmployee {
            employeeSpace.isHidden = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAvatarDisplay()
    }
    
    // MARK: Methods
    func setAvatar(to image: Data) { // displays Avatar
            self.avatar.setImage(UIImage(data: image), for: .normal)
    }
    
    func salesGotten() { // executes actions when presenter finishes getting Sales
        displayLoadView(false)
        
        performSegue(withIdentifier: SegueType.marketplace.rawValue, sender: self)
    }
    
    private func displayLoadView(_ displayed: Bool) { // Manages activityIndicator and grayOutView display
        avatar.isHidden = displayed
        grayOutView.isHidden = !displayed
        activityIndicator.isHidden = !displayed
    }
    
    private func setAvatarDisplay() { // Sets imageView up
        avatar.layer.cornerRadius = (avatar.frame.size.height) / 2
        avatar.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let destinationVC as EmployeeViewController:
            destinationVC.modalPresentationStyle = .fullScreen
        default:
            break
        }
    }
    
    // MARK: Actions
    @IBAction func goToMarketPlace(_ sender: Any) {
        displayLoadView(true)
        
        presenter.getSales()
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) { }
}
