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
    private let marketplaceManager: MarketplaceManager
    
    required init(view: DashboardView) {
        self.accountManager = AccountManager()
        self.view = view
        self.marketplaceManager = MarketplaceManager()
        
        super.init()
        
        setAvatar()
        registerForNotifications()
    }
    
    private func registerForNotifications() {
        let name = Notification.Name(rawValue: VigiCleanUser.NotificationType.avatar.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(setAvatar), name: name, object: nil)
    }
    
    init(accountManager: AccountManager, view: DashboardView, marketplaceManager: MarketplaceManager) {
        self.accountManager = accountManager
        self.marketplaceManager = marketplaceManager
        self.view = view
    }
    
    func getAvatar() {
        if VigiCleanUser.currentUser.avatar != nil {
            setAvatar()
        } else {
            accountManager.getAvatar { (result) in
                switch result {
                case .success:
                    self.setAvatar()
                case .failure(let error):
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
    
    func getSales() {
        if MarketplaceManager.sales.count < 1 {
            marketplaceManager.getSales { (error) in
                if let error = error {
                    self.view.displayError(message: self.convertError(error))
                    
                    return
                }
                
                print(MarketplaceManager.sales.count)
                self.view.salesGotten()
            }
        } else {
            self.view.salesGotten()
        }
    }
    
    @objc private func setAvatar() {
        DispatchQueue.main.async { // TODO: Ask to Nicolas
            let user = VigiCleanUser.currentUser
            
            guard let image = user.avatar else {
                return
            }
            
            self.view.setAvatar(to: image)
        }
    }
}
