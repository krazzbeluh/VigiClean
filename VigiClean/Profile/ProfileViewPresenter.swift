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
        return !VigiCleanUser.currentUser.isConnectedWithEmail
    }
    
    weak var view: ProfileView!
    
    required init(view: ProfileView) {
        self.view = view
        if VigiCleanUser.currentUser.isConnectedWithEmail {
            view.display(username: VigiCleanUser.currentUser.username ?? "")
            view.display(email: VigiCleanUser.currentUser.user?.email ?? "")
            
            guard let image = VigiCleanUser.currentUser.avatar else {
                return
            }
            
            view.display(avatar: image)
        }
    }
    
    init(view: ProfileView, accountManager: AccountManager) {
        self.accountManager = accountManager
        self.view = view
    }
    
    func signOut() {
        VigiCleanUser.currentUser.signOut { error in
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
        
        VigiCleanUser.currentUser.updatePseudo(to: newPseudo, with: password) { error in
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
        
        VigiCleanUser.currentUser.updateEmail(to: newEmail, with: password) { error in
            guard let error = error else {
                self.view.display(email: newEmail)
                return
            }
            
            self.view.displayError(message: self.convertError(error))
        }
    }
    
    func updateAvatar(to newAvatar: Data, with password: String?) {
        guard let password = password else {
            self.view.displayError(message: self.convertError(UserError.nilInTextField))
            return
        }
        
        accountManager.updateAvatar(from: newAvatar, with: password) { (result) in
            switch result {
            case .success(let imageData):
                self.view.display(avatar: imageData)
            case .failure(let error):
                self.view.displayError(message: self.convertError(error))
            }
        }
    }
    
    func updatePassword(to newPassword: String?, confirm: String?, with password: String?) {
        guard let password = password, let newPassword = newPassword, let confirm = confirm,
            newPassword == confirm else {
                return
        }
        
        VigiCleanUser.currentUser.updatePassword(to: newPassword, from: password) { (error) in
            guard let error = error else {
                self.view.passwordChanged()
                return
            }
            
            self.view.displayError(message: self.convertError(error))
        }
    }
}
