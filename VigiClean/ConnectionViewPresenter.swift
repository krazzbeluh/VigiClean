//
//  ConnectionViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 13/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ConnectionViewPresenter {
    init() {}
    
    func inscription(email: String?, password: String?, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let email = email, let password = password else {
            print("erreur")
            return
        }
        
        UserAccount.inscription(email: email, password: password) { result in
            completion(result)
        }
    }
    
    func connection(email: String?, password: String?, completion: @escaping ((Result<Void, Error>) -> Void)) {
        guard let email = email, let password = password else {
            print("erreur")
            return
        }
        
        UserAccount.connection(email: email, password: password) { result in
            completion(result)
        }
    }
}
