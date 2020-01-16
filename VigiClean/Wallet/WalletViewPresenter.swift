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
    
    var sales = [Sale]()
    
    required init(view: WalletView) {
        self.view = view
        
        self.marketplaceManager = MarketplaceManager()
    }
    
    func getUserSales() {
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
