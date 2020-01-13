//
//  FakeMarketplaceView.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class FakeMarketplaceView: MarketplaceView {
    var didCallSetScoreLabel = false
    
    func setScoreLabel(to text: String) {
        didCallSetScoreLabel = true
    }
}
