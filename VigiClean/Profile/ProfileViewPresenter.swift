//
//  ProfileViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ProfilePresenter: BasePresenter, ProfileViewPresenter {
    
    var isConnectedAnonymously: Bool {
        return !AccountManager.shared.isConnectedWithEmail
    }
    
    weak var view: ProfileView!
    
    required init(view: ProfileView) {
        self.view = view
        if AccountManager.shared.isConnectedWithEmail {
            view.display(username: AccountManager.shared.currentUser.username ?? "")
            view.display(email: AccountManager.shared.currentUser.user?.email ?? "")
        }
    }
    
    func signOut() {
        AccountManager.shared.signOut { error in
            if let error = error {
                guard let errMessage = self.getAuthErrorCode(error: error) else {
                    // TODO
                    return
                }
                
                self.view.sendAlert(message: errMessage)
            } else {
                self.view.userSignedOut()
            }
        }
    }
    
    func updatePseudo(to newPseudo: String?, with password: String?) {
        guard let newPseudo = newPseudo,
            let password = password else {
                return
        }
        
        AccountManager.shared.updatePseudo(to: newPseudo, with: password) { error in
            guard let error = error else {
                self.view.display(username: newPseudo)
                return
            }
            
            guard let errMessage = self.getStorageErrorCode(error: error) else {
                // TODO
                return
            }
            
            self.view.sendAlert(message: errMessage)
        }
    }
    
    func updateEmail(to newEmail: String?, with password: String?) {
        guard let newEmail = newEmail,
            let password = password else {
                return
        }
        
        AccountManager.shared.updateEmail(to: newEmail, with: password) { error in
            guard let error = error else {
                self.view.display(email: newEmail)
                return
            }
            
            guard let errMessage = self.getAuthErrorCode(error: error) else {
                // TODO
                return
            }
            
            self.view.sendAlert(message: errMessage)
        }
    }
}
