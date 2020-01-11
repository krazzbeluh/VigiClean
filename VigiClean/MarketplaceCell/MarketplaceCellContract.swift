//
//  MarketplaceCellContract.swift
//  VigiClean
//
//  Created by Paul Leclerc on 11/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

protocol MarketplaceCellViewPresenter: BasePresenter {
    init(view: MarketplaceCellView, sale: Sale)
    var sale: Sale { get }
    func buySale()
}

protocol MarketplaceCellView: class {
}
