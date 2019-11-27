//
//  AttachEmailViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 25/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol AttachEmailViewPresenter {
    init(view: AttachEmailView)
    func attachEmail(username: String?, email: String?, password: String?, confirmPassword: String?)
}

class AttachEmailPresenter: AttachEmailViewPresenter {
    unowned let view: AttachEmailView
    
    required init(view: AttachEmailView) {
        self.view = view
    }
    
    func attachEmail(username: String?, email: String?, password: String?, confirmPassword: String?) {
        guard let username = username,
            let email = email,
            let password = password,
            let confirmPassword = confirmPassword,
            username != "", email != "",
            password != "",
            confirmPassword != "" else {
                view.showAlert(with: UserAccount.UAccountError.emptyTextField)
            return
        }
        
        guard password == confirmPassword else {
            view.showAlert(with: UserAccount.UAccountError.notMatchingPassword)
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        UserAccount.attachEmail(email: email, password: password, completion: { error in
            if let error = error {
                self.view.showAlert(with: error)
            } else {
                self.view.emailAttached()
            }
        })
    }
}
