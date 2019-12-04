//
//  WelcomeViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class WelcomePresenter: WelcomeViewPresenter {
    unowned let view: WelcomeView
    
    required init(view: WelcomeView) {
        self.view = view
    }
    
    func signIn() {
        UserAccount.anonymousSignIn { error in
            if let error = error {
                self.view.sendAlert(message: SharedMethodsPresenter.prepareAlert(with: error))
                return
            }
            self.view.performSegue()
        }
    }
}
