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
    
    required init(view: SignUpView) {
        self.view = view
    }
    
    func signUp(username: String?, email: String?, password: String?, confirmPassword: String?) {
        guard let username = username,
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            username != "", email != "",
            password != "",
            confirmPassword != "" else {
//                view.sendAlert(message: convertAlert(with:
//                    AccountManager.UAccountError.emptyTextField)) // TODO
            return
        }
        
        guard password == confirmPassword else {
//            view.sendAlert(message: convertAlert(with:
//                AccountManager.UAccountError.notMatchingPassword)) // TODO
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        AccountManager.shared.signUp(username: username, email: email, password: password) { error in
            if let error = error {
                guard let errMessage = self.getAuthErrorCode(error: error) else {
//                    self.view.sendAlert(message: self.convertAlert(with: error)) // TODO
                    self.view.switchActivityIndicator(hidden: true)
                    return
                }
                self.view.sendAlert(message: errMessage)
                self.view.switchActivityIndicator(hidden: true)
                return
            } else {
                self.view.userSignedUp()
            }
        }
    }
}
