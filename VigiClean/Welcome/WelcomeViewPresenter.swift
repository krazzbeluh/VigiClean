//
//  WelcomeViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class WelcomePresenter: BasePresenter, WelcomeViewPresenter {
    weak var view: WelcomeView!
    
    required init(view: WelcomeView) {
        self.view = view
    }
    
    func signIn() {
        AccountManager.shared.anonymousSignIn { error in
            if let error = error {
                self.view.sendAlert(message: self.convertError(error))
                return
            }
            self.view.performSegue()
        }
    }
}
