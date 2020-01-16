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
    private let accountManager: AccountManager
    
    private var gottenDocument = false
    private func documentGotten() {
        gottenDocument = true
        checkIfAllDataIsGotten()
    }
    private var gottenAvatar = true
    private func avatarGotten() {
        gottenAvatar = true
        checkIfAllDataIsGotten()
    }
    
    var isUserConnected: Bool {
        return VigiCleanUser.currentUser.isConnected
    }
    
    required init(view: LaunchView) {
        self.view = view
        self.accountManager = AccountManager()
    }
    
    func listenForUserDocumentChanges() {
        accountManager.listenForUserDocumentChanges { 
            self.documentGotten()
        }
    }
    
    init(view: LaunchView, accountManager: AccountManager) {
        self.view = view
        self.accountManager = accountManager
    }
    
    func getAvatar() {
        accountManager.getAvatar { error in
            if let error = error {
                if let error = error as? StorageErrorCode,
                    error == .objectNotFound {
                    print("No avatar found")
                    self.avatarGotten()
                    return
                }
                self.view.displayError(message: self.convertError(error))
                self.avatarGotten()
                return
            }
            
            self.avatarGotten()
        }
    }
    
    private func checkIfAllDataIsGotten() {
        if gottenAvatar && gottenDocument {
            view.allResponseRecieved()
        }
    }
}
