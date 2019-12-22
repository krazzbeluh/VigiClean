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
    private let accountManager = AccountManager()
    
    required init(view: ScoreViewContract) {
        self.view = view
    }
    
    func listenForUserCreditChange(valueChanged: @escaping (Int) -> Void) {
        accountManager.listenForUserDocumentChanges { (newValue) in
            valueChanged(newValue)
        }
    }
    
    func getColorCode(for score: Int) -> Color {
        return Color(red: redValue(for: score), green: greenValue(for: score), blue: 0, alpha: 1)
    }
    
    private func redValue(for score: Int) -> Double {
        var value: Double = 1
        if score > 50 {
            value = Double(100 - score) / 50
        }
        return value * 0.85
    }
    
    private func greenValue(for score: Int) -> Double {
        var value: Double = 1
        if score <= 50 {
            value = Double(score) / 50
        }
        return value * 0.85
    }
}
