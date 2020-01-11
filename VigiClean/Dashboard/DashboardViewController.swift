//
//  DashboardViewController.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import UIKit

// TODO: move to presenter
class DashboardViewController: UIViewController, DashboardView {
    // MARK: Outlets
    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var avatar: UIButton!
    @IBOutlet weak var grayOutView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var presenter: DashboardViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(view: self)
        
        let name = Notification.Name(rawValue: VigiCleanUser.NotificationType.avatar.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(setAvatar), name: name, object: nil)
        
        setAvatar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setAvatarDisplay()
    }
    
    // MARK: Methods
    @objc func setAvatar() {
        DispatchQueue.main.async { // TODO: Ask to Nicolas
            let user = AccountManager.currentUser
            
            guard let image = user.avatar else {
                return
            }
            
            self.avatar.setImage(UIImage(data: image), for: .normal)
        }
    }
    
    func salesGotten() {
        displayLoadView(false)
        
        performSegue(withIdentifier: "segueToMarketplace", sender: self)
    }
    
    private func displayLoadView(_ displayed: Bool) {
        avatar.isHidden = displayed
        grayOutView.isHidden = !displayed
        activityIndicator.isHidden = !displayed
    }
    
    private func setAvatarDisplay() {
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
