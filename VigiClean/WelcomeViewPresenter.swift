//
//  WelcomeViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol WelcomeViewPresenter {
    init(view: WelcomeView)
    func signIn()
    func performSegueIfUserIsConnected()
}

class WelcomePresenter: WelcomeViewPresenter {
    unowned let view: WelcomeView
    
    required init(view: WelcomeView) {
        self.view = view
    }
    
    func signIn() {
        UserAccount.anonymousSignIn { error in
            guard error == nil else {
                self.view.showAlert(with: error!)
                return
            }
            self.view.performSegue()
        }
    }
    
    func performSegueIfUserIsConnected() {
        if UserAccount.isConnected {
            view.performSegue()
        }
    }
}
