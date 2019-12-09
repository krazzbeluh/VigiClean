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
}
