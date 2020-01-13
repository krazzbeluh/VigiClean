//
//  MarketplaceCellViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 11/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class MarketplaceCellPresenter: BasePresenter, MarketplaceCellViewPresenter {
    weak var view: MarketplaceCellView!
    
    required init(view: MarketplaceCellView, sale: Sale) {
        self.view = view
        self.sale = sale
        marketplaceManager = MarketplaceManager()
    }
    
    init(view: MarketplaceCellView, sale: Sale, marketplaceManager: MarketplaceManager) {
        self.view = view
        self.sale = sale
        self.marketplaceManager = marketplaceManager
    }
    
    let sale: Sale
    private var marketplaceManager: MarketplaceManager
    
    func buySale() {
        guard sale.price <= VigiCleanUser.currentUser.credits else {
            view.sendAlert(with: convertError(AccountManager.UAccountError.notEnoughCredits))
            return
        }
        
        marketplaceManager.buySale(sale: sale) { (result) in
            switch result {
            case .success(let code):
                self.view.saleGotten(with: code)
            case .failure(let error):
                self.view.sendAlert(with: self.convertError(error))
            }
        }
    }
}
