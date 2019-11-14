//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol SignInViewPresenter {
    init(view: SignInView)
    func signIn(email: String?, password: String?)
}

class SignInPresenter: SignInViewPresenter {
    unowned let view: SignInView
    
    required init(view: SignInView) {
        self.view = view
    } 
    
    func signIn(email: String?, password: String?) {
        guard let email = email, let password = password else {
            print("erreur")
            return
        }
        
        UserAccount.signIn(email: email, password: password) { result in
            switch result {
            case .failure(let error):
                self.view.showAlert(with: error)
            case .success:
                self.view.performSegue()
            }
        }
    }
}