//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class SignInPresenter: SignInViewPresenter {
    unowned let view: SignInView
    
    required init(view: SignInView) {
        self.view = view
    } 
    
    func signIn(email: String?, password: String?) {
        guard let email = email, let password = password, email != "", password != "" else {
            view.showAlert(with: UserAccount.UAccountError.emptyTextField)
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        UserAccount.signIn(email: email, password: password) { error in
            guard error == nil else {
                self.view.showAlert(with: error!)
                return
            }
            self.view.userSignedIn()
        }
    }
}
