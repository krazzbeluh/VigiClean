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
}

class ChooseAccountingMethodPresenter: ChooseAccountingMethodViewPresenter {
    unowned let view: ChooseAccountingMethodView
    
    required init(view: ChooseAccountingMethodView) {
        self.view = view
    }
    
    func signIn() {
        UserAccount.anonymousSignIn { result in
            switch result {
            case .success:
                self.view.performSegue()
            case .failure(let error):
                self.view.showAlert(with: error)
            }
        }
    }
}
