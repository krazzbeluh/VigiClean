//
//  SignUpViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class SignUpPresenter: BasePresenter, SignUpViewPresenter {
    weak var view: SignUpView!
    private var accountManager = AccountManager()
    
    required init(view: SignUpView) {
        self.view = view
    }
    
    init(view: SignUpView, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
    }
    
    func signUp(username: String?, email: String?, password: String?, confirmPassword: String?) {
        guard let username = username,
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            username != "", email != "",
            password != "",
            confirmPassword != "" else {
                view.displayError(message: convertError(UserError.nilInTextField))
                return
        }
        
        guard password == confirmPassword else {
            view.displayError(message: convertError(AccountManager.UAccountError.notMatchingPassword))
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        accountManager.signUp(username: username, email: email, password: password) { error in
            if let error = error {
                self.view.displayError(message: self.convertError(error))
                self.view.switchActivityIndicator(hidden: true)
                return
            } else {
                self.view.userSignedUp()
            }
        }
    }
}
