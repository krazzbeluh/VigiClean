//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class SignInPresenter: BasePresenter, SignInViewPresenter {
    weak var view: SignInView!
    private var accountManager = AccountManager()
    
    required init(view: SignInView) {
        self.view = view
    }
    
    init(view: SignInView, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
    }
    
    func signIn(email: String?, password: String?) {
        guard let email = email, let password = password, email != "", password != "" else {
            view.switchActivityIndicator(hidden: true)
            view.displayError(message: convertError(AccountManager.UAccountError.emptyTextField))
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        accountManager.signIn(email: email, password: password) { error in
            if let error = error {
                self.view.displayError(message: self.convertError(error))
                return
            }
            self.accountManager.getAvatar { _ in }
            self.view.userSignedIn()
        }
    }
}
