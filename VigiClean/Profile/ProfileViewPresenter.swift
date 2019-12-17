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
}
