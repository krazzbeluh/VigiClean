//
//  ScoreViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ScoreViewPresenter: ScoreViewPresenterContract {
    weak var view: ScoreViewContract!
    private var accountManager = AccountManager()
    
    init(view: ScoreViewContract, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
        
    }
    
    required init(view: ScoreViewContract) {
        self.view = view
        registerForNotifications()
    }
    
    // listens for score changes
    private func registerForNotifications() {
        let name = Notification.Name(rawValue: VigiCleanUser.NotificationType.score.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(scoreChanged), name: name, object: nil)
    }
    
    @objc private func scoreChanged() {  // updates view score to new score
        self.view.scoreValueChanged(to: VigiCleanUser.currentUser.credits)
    }
    
    func getScore() { // calls scoreChanged on launch
        scoreChanged()
    }
    
    func getColorCode(for score: Int) -> Color { // returns view color
        return Color(red: redValue(for: score), green: greenValue(for: score), blue: 0, alpha: 1)
    }
    
    private func redValue(for score: Int) -> Double {
        // calculatesred value for view color
        var value: Double = 1
        if score > 50 {
            value = Double(100 - score) / 50
        }
        return value * 0.85
    }
    
    private func greenValue(for score: Int) -> Double {
        // calculates green value for view color
        var value: Double = 1
        if score <= 50 {
            value = Double(score) / 50
        }
        return value * 0.85
    }
}
