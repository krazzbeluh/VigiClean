//
//  MarketplaceManagerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class MarketplaceManagerTestCase: XCTestCase {
    func testGetSalesShouldReturnSuccessCallbackIfNoError() {
        let datas: [[String: Any]] = [["title": "",
                                       "littleText": "",
                                       "partner": "",
                                       "description": "",
                                       "image": "https://vigiclean.com",
                                       "price": 3
            ]]
        let database = FirestoreFake(errors: nil, datas: datas)
        let marketplaceManager = MarketplaceManager(database: database)
        
        marketplaceManager.getSales { error in
            XCTAssertNil(error)
        }
    }
    
    func testGetSalesShouldReturnFailureCallbackIfError() {
        let database = FirestoreFake(errors: [EasyError()])
        let marketplaceManager = MarketplaceManager(database: database)
        
        marketplaceManager.getSales { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testGetSalesShouldReturnFailureCallbackIfNoDataAndNoError() {
        let database = FirestoreFake(errors: nil)
        let marketplaceManager = MarketplaceManager(database: database)
        
        marketplaceManager.getSales { error in
            XCTAssertNotNil(error)
        }
    }
    
    func testGetSalesShouldReturnSuccessCallbackIfInvalidData() {
        let datas: [[String: Any]] = [["title": "",
                                       "littleText": "",
                                       "partner": "",
                                       "image": "https://vigiclean.com",
                                       "price": 3
            ]]
        let database = FirestoreFake(errors: nil, datas: datas)
        let marketplaceManager = MarketplaceManager(database: database)
        
        marketplaceManager.getSales { error in
            XCTAssertNil(error)
            XCTAssertEqual(MarketplaceManager.sales.count, 0)
        }
    }
    
    func testBuySaleShouldReturnSuccessCallbackIfNoError() {
        let marketplaceManager = MarketplaceManager(functions: FunctionsFake(error: nil, data: ["saleCode": ""]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        let sale = Sale(price: 1,
                        image: URL(string: "https://www.vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        
        marketplaceManager.buySale(sale: sale) { (result) in
            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testBuySaleShouldReturnFailureCallbackIfError() {
        let marketplaceManager = MarketplaceManager(functions: FunctionsFake(error: EasyError(), data: nil))
        
        let sale = Sale(price: 1,
                        image: URL(string: "https://www.vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        
        marketplaceManager.buySale(sale: sale) { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testBuySaleShouldReturnFailureCallbackIfNoData() {
        let marketplaceManager = MarketplaceManager(functions: FunctionsFake(error: nil, data: nil))
        
        let sale = Sale(price: 1,
                        image: URL(string: "https://www.vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        
        marketplaceManager.buySale(sale: sale) { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testBuySaleShouldReturnFailureCallbackIfUserNotLoggedIn() {
        let marketplaceManager = MarketplaceManager()
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        VigiCleanUser.currentUser.auth = auth
        
        let sale = Sale(price: 1,
                        image: URL(string: "https://www.vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        
        marketplaceManager.buySale(sale: sale) { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
}
