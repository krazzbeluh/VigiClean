//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ConnectionViewPresenter {
    let userAccount = UserAccount()
    init() {}
    
    func inscription(email: String?, password: String?) {
        guard let email = email, let password = password else {
            print("erreur")
            return
        }
        userAccount.inscription(email: email, password: password)
    }
}
