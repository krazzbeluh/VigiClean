//
//  FakeMarketplaceCellView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeMarketplaceCellView: MarketplaceCellView {
    var didCallSendAlert = false
    var didCallSaleGotten = false
    
    func sendAlert(with message: String) {
        didCallSendAlert = true
    }
    
    func saleGotten(with code: String) {
        didCallSaleGotten = true
    }
}
