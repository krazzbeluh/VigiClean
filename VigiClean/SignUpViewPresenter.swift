//
//  SignUpViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol SignUpViewPresenter {
    init(view: SignUpView)
    func signUp(username: String?, email: String?, password: String?, confirmPassword: String?)
}

class SignUpPresenter: SignUpViewPresenter {
    unowned let view: SignUpView
    
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
            print("erreur")
            return
        }
        
        guard password == confirmPassword else {
            print("erreur")
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        UserAccount.signUp(email: email, password: password) { error in
            guard error == nil else {
                self.view.showAlert(with: error!)
                self.view.switchActivityIndicator(hidden: true)
                return
            }
            self.view.performSegue()
        }
    }
}
