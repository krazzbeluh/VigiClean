//
//  LaunchViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage

class LaunchPresenter: BasePresenter, LaunchViewPresenter {
    weak var view: LaunchView!
    private let accountManager = AccountManager()
    
    var isUserConnected: Bool {
        return VigiCleanUser.currentUser.isConnected
    }
    
    required init(view: LaunchView) {
        self.view = view
    }
    
    func getAvatar() {
        accountManager.getAvatar { (result) in
            switch result {
            case .success:
                self.view.gottenAvatar()
            case .failure(let error):
                self.view.gottenAvatar()
                if let error = error as? StorageErrorCode,
                    error == .objectNotFound {
                    print("No avatar found")
                    return
                }
                self.view.displayError(message: self.convertError(error))
            }
        }
    }
}
