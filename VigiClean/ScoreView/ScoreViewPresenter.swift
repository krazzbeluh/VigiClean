//
//  ScoreViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ScoreViewPresenter: ScoreViewPresenterContract {
    unowned let view: ScoreViewContract
    
    let accountManager = AccountManager()
    
    required init(view: ScoreViewContract) {
        self.view = view
    }
    
    func listenForUserCreditChange(valueChanged: @escaping (Int) -> Void) {
        accountManager.listenForUserCreditsChanges { newValue in
            valueChanged(newValue)
        }
    }
    
    func getColorCode(for score: Int) -> Color {
        return Color(r: redValue(for: score), g: greenValue(for: score), b: 0, a: 1)
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
