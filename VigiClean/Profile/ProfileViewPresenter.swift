//
//  ProfileViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ProfilePresenter: BasePresenter, ProfileViewPresenter {
    
    let accountManager = AccountManager()
    
    var isConnectedAnonymously: Bool {
        return !accountManager.isConnectedWithEmail
    }
    
    weak var view: ProfileView!
    
    required init(view: ProfileView) {
        self.view = view
        if accountManager.isConnectedWithEmail {
            view.display(username: "")
        }
    }
    
    func signOut() {
        accountManager.signOut { error in
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
        
        accountManager.updatePseudo(to: newPseudo) { error in
            guard let error = error else {
                self.view.display(username: newPseudo)
                return
            }
            
            self.view.sendAlert(message: self.convertAlert(with: error))
        }
    }
}
