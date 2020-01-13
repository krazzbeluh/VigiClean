//
//  DashboardViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 25/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage
import XCTest
@testable import VigiClean

class DashboardViewPresenterTestCase: XCTestCase {
    var view: FakeDashboardView!
    
    override func setUp() {
        self.view = FakeDashboardView()
        MarketplaceManager.sales = [Sale]()
    }
    
    func testgetAvatarShouldCallViewSetAvatarIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for queue change")
        VigiCleanUser.currentUser.avatar = Data()
        let view = FakeDashboardView {
            expectation.fulfill()
        }
        let accountManager = AccountManagerFake(errors: [nil])
        let presenter = DashboardPresenter(accountManager: accountManager, view: view)
        
        presenter.getAvatar()
        
        wait(for: [expectation], timeout: 1)
        XCTAssertTrue(view.didCallSetAvatarToImage)
        XCTAssertFalse(view.didCallSendAlert)
    }
    
    func testgetAvatarShouldCallViewSendAlertIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for queue change")
        VigiCleanUser.currentUser.avatar = Data()
        let view = FakeDashboardView {
            expectation.fulfill()
        }
        let accountManager = AccountManagerFake(errors: [EasyError()])
        let presenter = DashboardPresenter(accountManager: accountManager, view: view)
        
        presenter.getAvatar()
        
        wait(for: [expectation], timeout: 1)
        XCTAssertFalse(view.didCallSetAvatarToImage)
        XCTAssertTrue(view.didCallSendAlert)
    }
    
    func testgetAvatarShouldNotCallViewSendAlertIfFailureWithObjectNotFound() {
        let accountManager = AccountManagerFake(errors: [StorageErrorCode.objectNotFound])
        let marketplaceManager = MarketplaceManager()
        let presenter = DashboardPresenter(accountManager: accountManager,
                                           view: view,
                                           marketplaceManager: marketplaceManager)
        
        presenter.getAvatar()
        
        XCTAssertFalse(view.didCallSetAvatar)
        XCTAssertFalse(view.didCallSendAlert)
    }
    
    func testGetSalesShouldCallSalesGottenIfSalesIsNotVoid() {
        MarketplaceManager.sales = [Sale(price: 1,
                                         image: URL(string: "https://www.vigiclean.com")!,
                                         title: "",
                                         littleTitle: "",
                                         partner: "",
                                         description: "",
                                         code: "")]
        
        let presenter = DashboardPresenter(view: view)
        presenter.getSales()
        
        XCTAssertTrue(view.didCallSalesGotten)
    }
    
    func testGetSalesShouldCallSalesGottenIfNoError() {
        XCTAssertFalse(view.didCallSalesGotten)
        let marketplaceManager = MarketplaceManagerFake(error: nil)
        let presenter = DashboardPresenter(view: view, marketplaceManager: marketplaceManager)
        presenter.getSales()
        
        XCTAssertTrue(view.didCallSalesGotten)
    }
    
    func testGetSalesShouldCallDisplayErrorIfError() {
        XCTAssertFalse(view.didCallSalesGotten)
        let marketplaceManager = MarketplaceManagerFake(error: EasyError())
        let presenter = DashboardPresenter(view: view, marketplaceManager: marketplaceManager)
        presenter.getSales()
        
        XCTAssertTrue(view.didCallSendAlert)
    }
}
