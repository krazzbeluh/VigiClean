//
//  MarketplaceCellPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class MarketplaceCellPresenterTestCase: XCTestCase {
    func testBuySaleShouldCallSaleGottenIfNoError() {
        let view = FakeMarketplaceCellView()
        let sale = Sale(price: 1,
                        image: URL(string: "https://vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        let marketplaceManager = MarketplaceManagerFake(resultString: .success(""))
        let presenter = MarketplaceCellPresenter(view: view, sale: sale, marketplaceManager: marketplaceManager)
        
        VigiCleanUser.currentUser.credits = 1
        
        presenter.buySale()
        
        XCTAssertTrue(view.didCallSaleGotten)
    }
    
    func testBuySaleShouldCallSendAlertIfError() {
        let view = FakeMarketplaceCellView()
        let sale = Sale(price: 1,
                        image: URL(string: "https://vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        let marketplaceManager = MarketplaceManagerFake(resultString: .failure(EasyError()))
        let presenter = MarketplaceCellPresenter(view: view, sale: sale, marketplaceManager: marketplaceManager)
        
        VigiCleanUser.currentUser.credits = 1
        
        presenter.buySale()
        
        XCTAssertTrue(view.didCallSendAlert)
    }
    
    func testBuySaleShouldCallSendAlertIfNotEnoughCredits() {
        let view = FakeMarketplaceCellView()
        let sale = Sale(price: 1,
                        image: URL(string: "https://vigiclean.com")!,
                        title: "",
                        littleTitle: "",
                        partner: "",
                        description: "",
                        code: "")
        let presenter = MarketplaceCellPresenter(view: view, sale: sale)
        
        VigiCleanUser.currentUser.credits = 0
        
        presenter.buySale()
        
        XCTAssertTrue(view.didCallSendAlert)
    }
}
