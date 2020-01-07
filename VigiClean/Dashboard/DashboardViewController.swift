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
        setAvatarDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.getAvatar() // TODO: NOT WORKING (maybe I should use notifications)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Methods
    func setAvatar(with image: Data) {
        avatar.setImage(UIImage(data: image), for: .normal)
    }
    
    private func setAvatarDisplay() {
        avatar.layer.borderWidth = 1
        avatar.layer.borderColor = UIColor(named: "Background")?.cgColor
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = avatar.frame.height / 2 // TODO: Not working expectedly
        avatar.clipsToBounds = true
    }
}
