//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class SignInPresenter: SignInViewPresenter {
    weak let view: SignInView
    
    required init(view: SignInView) {
        self.view = view
    } 
    
    func signIn(email: String?, password: String?) {
        guard let email = email, let password = password, email != "", password != "" else {
            view.switchActivityIndicator(hidden: true)
            view.sendAlert(message: SharedMethodsPresenter.prepareAlert(with: UserAccount.UAccountError.emptyTextField))
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        UserAccount.signIn(email: email, password: password) { error in
            if let error = error {
                self.view.switchActivityIndicator(hidden: true)
                self.view.sendAlert(message: SharedMethodsPresenter.prepareAlert(with: error))
                return
            }
            self.view.userSignedIn()
        }
    }
}
