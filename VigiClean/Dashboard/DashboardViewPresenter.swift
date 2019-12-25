//
//  DashboardViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage

class DashboardPresenter: BasePresenter, DashboardViewPresenter {
    weak var view: DashboardView!
    private let accountManager: AccountManager
    
    required init(view: DashboardView) {
        self.accountManager = AccountManager()
        self.view = view
    }
    
    init(accountManager: AccountManager, view: DashboardView) {
        self.accountManager = accountManager
        self.view = view
    }
    
    func getAvatar() {
        accountManager.getAvatar { (result) in
            switch result {
            case .success(let data):
                self.view.setAvatar(with: data)
            case .failure(let error):
                if let error = error as? StorageErrorCode,
                    error == .objectNotFound {
                    print("No avatar found")
                    return
                }
                self.view.sendAlert(message: self.convertError(error))
            }
        }
        
    }
}
