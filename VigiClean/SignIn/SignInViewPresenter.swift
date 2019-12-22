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
    
    required init(view: SignInView) {
        self.view = view
    } 
    
    func signIn(email: String?, password: String?) {
        guard let email = email, let password = password, email != "", password != "" else {
            view.switchActivityIndicator(hidden: true)
            view.sendAlert(message: convertError(AccountManager.UAccountError.emptyTextField))
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        AccountManager.shared.signIn(email: email, password: password) { error in
            if let error = error {
                self.view.sendAlert(message: self.convertError(error))
            }
            self.view.userSignedIn()
        }
    }
}
