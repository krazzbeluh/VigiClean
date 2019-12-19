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
        }
    }
    
    func signOut() {
        AccountManager.shared.signOut { error in
            if let error = error {
                self.view.sendAlert(message: self.convertAlert(with: error))
            } else {
                self.view.userSignedOut()
            }
        }
    }
    
    func updatePseudo(to newPseudo: String?) {
        guard let newPseudo = newPseudo else {
            return
        }
        
        AccountManager.shared.updatePseudo(to: newPseudo) { error in
            guard let error = error else {
                self.view.display(username: newPseudo)
                return
            }
            
            self.view.sendAlert(message: self.convertAlert(with: error))
        }
    }
}
