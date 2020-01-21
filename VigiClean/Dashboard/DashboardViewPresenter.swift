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
    
    var isEmployee: Bool {
        return VigiCleanUser.currentUser.isEmployee
    }
    
    required init(view: DashboardView) {
        self.accountManager = AccountManager()
        self.view = view
        print(2)
        self.marketplaceManager = MarketplaceManager()
        
        super.init()
        
        setAvatar()
        registerForNotifications()
    }
    
    init(accountManager: AccountManager? = nil, view: DashboardView, marketplaceManager: MarketplaceManager? = nil) {
        self.accountManager = accountManager ?? AccountManager()
        self.marketplaceManager = marketplaceManager ?? MarketplaceManager()
        self.view = view
        print(1)
        super.init()
    }
    
    private func registerForNotifications() { // Waits for avatar changes
        let name = Notification.Name(rawValue: VigiCleanUser.NotificationType.avatar.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(setAvatar), name: name, object: nil)
    }
    
    func getAvatar() { // Gets Avatar from accountManager
        accountManager.getAvatar { (error) in
            if let error = error {
                if let error = error as? StorageErrorCode,
                    error == .objectNotFound {
                    print("No avatar found")
                    return
                }
                self.view.displayError(message: self.convertError(error))
                return
            }
            self.setAvatar()
        }
    }
    
    func getSales() { // Gets sales from MarketplaceManager and calls salesGotter from view
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
    
    @objc private func setAvatar() { // Sends avatar from VCUser to view
        DispatchQueue.main.async { // TODO: Ask to Nicolas
            let user = VigiCleanUser.currentUser
            
            guard let image = user.avatar else {
                return
            }
            
            self.view.setAvatar(to: image)
        }
    }
}
