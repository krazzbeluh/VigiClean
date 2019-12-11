//
//  AttachEmailViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 25/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class AttachEmailPresenter: BasePresenter, AttachEmailViewPresenter {
    weak var view: AttachEmailView!
    
    let accountManager = AccountManager()
    
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
                view.sendAlert(message: convertAlert(with:
                    AccountManager.UAccountError.emptyTextField))
            return
        }
        
        guard password == confirmPassword else {
            view.sendAlert(message: convertAlert(with:
                AccountManager.UAccountError.notMatchingPassword))
            return
        }
        
        view.switchActivityIndicator(hidden: false)
        
        accountManager.attachEmail(email: email, password: password, completion: { error in
            if let error = error {
                self.view.sendAlert(message: self.convertAlert(with: error))
            } else {
                self.view.emailAttached()
            }
        })
    }
}