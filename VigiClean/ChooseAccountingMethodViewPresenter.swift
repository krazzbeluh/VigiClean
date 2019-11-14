//
//  ChooseAccountingMethodViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol ChooseAccountingMethodViewPresenter {
    init(view: ChooseAccountingMethodView)
    func signIn()
    func checkConnection()
}

class ChooseAccountingMethodPresenter: ChooseAccountingMethodViewPresenter {
    unowned let view: ChooseAccountingMethodView
    
    required init(view: ChooseAccountingMethodView) {
        self.view = view
    }
    
    func signIn() {
        UserAccount.anonymousSignIn { error in
            guard error == nil else {
                self.view.showAlert(with: error!)
                return
            }
            self.view.performSegue()
        }
    }
    
    func checkConnection() {
        if UserAccount.checkConnection() {
            view.performSegue()
        }
    }
}
