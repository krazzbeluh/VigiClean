//
//  MarketplaceContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 10/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

protocol MarketplaceViewPresenter {
    init(view: MarketplaceView)
    func getScore()
}

protocol MarketplaceView: class {
    func setScoreLabel(to text: String)
}
