//
//  MarketplaceViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class MarketplacePresenter: MarketplaceViewPresenter {
    weak var view: MarketplaceView!
    
    private var listener: (() -> Void)?
    
    func getScore() {
        setScore()
    }
    
    required init(view: MarketplaceView) {
        self.view = view
        
        // listens for score change
        let name = Notification.Name(rawValue: VigiCleanUser.NotificationType.score.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(setScore), name: name, object: nil)
    }
    
    init(view: MarketplaceView, listener: (() -> Void)? = nil) {
        self.view = view
        self.listener = listener
    }
    
    @objc func setScore() { // sets score to view on score change
        DispatchQueue.main.async { // TODO: Ask to Nicolas
            self.view.setScoreLabel(to: "\(VigiCleanUser.currentUser.credits) points")
            self.listener?()
        }
    }
}
