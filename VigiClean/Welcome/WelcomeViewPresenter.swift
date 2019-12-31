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
    private var accountManager = AccountManager()
    
    required init(view: WelcomeView) {
        self.view = view
    }
    
    init(view: WelcomeView, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
    }
    
    func signIn() {
        accountManager.anonymousSignIn { error in
            if let error = error {
                self.view.displayError(message: self.convertError(error))
                return
            }
            self.view.performSegue()
        }
    }
}
