//
//  WalletViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 16/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class WalletViewPresenterTestCase: XCTestCase {
    func testGetUserSalesShouldNotCallDisplayAlertIfNoError() {
        let view = FakeWalletView()
        let marketplaceManager = MarketplaceManagerFake(resultSales: .success([Sale]()))
        let presenter = WalletPresenter(view: view, marketplaceManager: marketplaceManager)
        
        presenter.getUserSales()
        
        XCTAssertTrue(view.didCallGottenResponse)
        XCTAssertFalse(view.didCallDisplayError)
    }
    
    func testGetUserSalesShouldCallDisplayAlertIfError() {
        let view = FakeWalletView()
        let marketplaceManager = MarketplaceManagerFake(resultSales: .failure(EasyError()))
        let presenter = WalletPresenter(view: view, marketplaceManager: marketplaceManager)
        
        presenter.getUserSales()
        
        XCTAssertTrue(view.didCallGottenResponse)
        XCTAssertTrue(view.didCallDisplayError)
    }
}
