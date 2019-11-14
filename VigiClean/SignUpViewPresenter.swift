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
    func signUp(email: String?, password: String?)
}

class SignUpPresenter: SignUpViewPresenter {
    unowned let view: SignUpView
    
    required init(view: SignUpView) {
        self.view = view
    }
    
    func signUp(email: String?, password: String?) {
        guard let email = email, let password = password else {
            print("erreur")
            return
        }
        
        UserAccount.signUp(email: email, password: password) { error in
            guard error == nil else {
                self.view.showAlert(with: error!)
                return
            }
            self.view.performSegue()
        }
    }
}
