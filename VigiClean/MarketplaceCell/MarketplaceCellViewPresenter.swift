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
    
    let sale: Sale
    private let marketplaceManager: MarketplaceManager
    
    func buySale() {
        guard sale.price <= AccountManager.currentUser.credits else {
            // TODO
            return
        }
        
        marketplaceManager.buySale(sale: sale) { (error) in
            print(error)
        }
    }
}
