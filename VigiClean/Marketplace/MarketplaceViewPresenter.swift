//
//  MarketplaceViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class MarketplacePresenter: MarketplaceViewPresenter {
    weak var view: MarketplaceView!
    
    required init(view: MarketplaceView) {
        self.view = view
    }
}
