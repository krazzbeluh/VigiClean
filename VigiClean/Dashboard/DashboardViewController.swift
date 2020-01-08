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
    @IBOutlet weak var avatar: UIButton!
    
    var presenter: DashboardViewPresenter!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DashboardPresenter(view: self)
        
        let name = Notification.Name(rawValue: "AvatarChanged")
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
    
    private func setAvatarDisplay() {
        avatar.layer.cornerRadius = (avatar.frame.size.height) / 2
        avatar.clipsToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? EmployeeViewController else {
            return
        }
        
        destinationVC.modalPresentationStyle = .fullScreen
    }
    
    @IBAction func unwindToDashboard(segue: UIStoryboardSegue) { }
}
