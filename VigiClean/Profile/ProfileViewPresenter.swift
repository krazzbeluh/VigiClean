//
//  ProfileViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ProfilePresenter: BasePresenter, ProfileViewPresenter {
    private var accountManager = AccountManager()
    
    var isConnectedAnonymously: Bool {
        return !accountManager.isConnectedWithEmail
    }
    
    weak var view: ProfileView!
    
    required init(view: ProfileView) {
        self.view = view
        if accountManager.isConnectedWithEmail {
            view.display(username: AccountManager.currentUser.username ?? "")
            view.display(email: AccountManager.currentUser.user?.email ?? "")
        }
    }
    
    init(view: ProfileView, accountManager: AccountManager) {
        self.accountManager = accountManager
        self.view = view
    }
    
    func signOut() {
        accountManager.signOut { error in
            if let error = error {
                self.view.displayError(message: self.convertError(error))
            } else {
                self.view.userSignedOut()
            }
        }
    }
    
    func updatePseudo(to newPseudo: String?, with password: String?) {
        guard let newPseudo = newPseudo,
            newPseudo != "",
            let password = password else {
                self.view.displayError(message: self.convertError(UserError.nilInTextField))
                return
        }
        
        accountManager.updatePseudo(to: newPseudo, with: password) { error in
            guard let error = error else {
                self.view.display(username: newPseudo)
                return
            }
            
            self.view.displayError(message: self.convertError(error))
        }
    }
    
    func updateEmail(to newEmail: String?, with password: String?) {
        guard let newEmail = newEmail,
            newEmail != "",
            let password = password else {
                self.view.displayError(message: self.convertError(UserError.nilInTextField))
                return
        }
        
        accountManager.updateEmail(to: newEmail, with: password) { error in
            guard let error = error else {
                self.view.display(email: newEmail)
                return
            }
            
            self.view.displayError(message: self.convertError(error))
        }
    }
}
