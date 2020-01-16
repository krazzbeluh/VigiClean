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
    private var resultString: Result<String, Error>?
    private var resultSales: Result<[Sale], Error>?
    private var error: Error?
    
    init(resultString: Result<String, Error>) {
        self.resultString = resultString
    }
    
    init(resultSales: Result<[Sale], Error>) {
        self.resultSales = resultSales
    }
    
    init(error: Error?) {
        self.error = error
    }
    
    override func buySale(sale: Sale, completion: @escaping (Result<String, Error>) -> Void) {
        completion(resultString!)
    }
    
    override func getSales(completion: @escaping (Error?) -> Void) {
        completion(error)
    }
    
    override func getUserSales(callback: @escaping ((Result<[Sale], Error>) -> Void)) {
        callback(resultSales!)
    }
}
