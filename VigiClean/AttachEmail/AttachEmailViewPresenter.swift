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
    private var accountManager = AccountManager()
    
    required init(view: AttachEmailView) {
        self.view = view
    }
    
    init(view: AttachEmailView, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
    }
    
    func attachEmail(username: String?, email: String?, password: String?, confirmPassword: String?) {
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
        
        VigiCleanUser.currentUser.attachEmail(email: email, password: password, completion: { error in
            if let error = error {
                self.view.displayError(message: self.convertError(error))
            } else {
                VigiCleanUser.currentUser.updatePassword(password: password) { (error) in
                    if let error = error {
                        self.view.displayError(message: self.convertError(error))
                    } else {
                        self.view.attachedEmail()
                    }
                }
            }
        })
    }
    
    func updatePseudo(username: String?, password: String?, confirmPassword: String?) {
        guard let username = username,
            let password = password,
            let confirmPassword = confirmPassword,
            username != "",
            password != "",
            confirmPassword != "" else {
                view.displayError(message: convertError(UserError.nilInTextField))
                return
        }
        
        VigiCleanUser.currentUser.updatePseudo(to: username, with: password) { (error) in
            guard let error = error else {
                self.view.updatedPseudo()
                return
            }
            
            self.view.displayError(message: self.convertError(error))
        }
    }
}
