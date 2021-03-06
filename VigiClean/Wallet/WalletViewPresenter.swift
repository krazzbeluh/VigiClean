//
//  WalletViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 15/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class WalletPresenter: BasePresenter, WalletViewPresenter {
    weak var view: WalletView!
    private let marketplaceManager: MarketplaceManager
    
    var sales = [Sale]() // stores every user's sales
    
    required init(view: WalletView) {
        self.view = view
        
        self.marketplaceManager = MarketplaceManager()
    }
    
    init(view: WalletView, marketplaceManager: MarketplaceManager) {
        self.view = view
        self.marketplaceManager = marketplaceManager
    }
    
    func getUserSales() { // gets user sales and call view method to display response
        marketplaceManager.getUserSales { (result) in
            switch result {
            case .success(let sales):
                self.sales = sales
            case .failure(let error):
                self.view.displayError(message: self.convertError(error))
            }
            self.view.gottenResponse()
        }
    }
}
