//
//  MarketplaceManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class MarketplaceManagerFake: MarketplaceManager {
    private let resultString: Result<String, Error>
    
    init(resultString: Result<String, Error>) {
        self.resultString = resultString
    }
    
    override func buySale(sale: Sale, complection: @escaping (Result<String, Error>) -> Void) {
        complection(resultString)
    }
}
