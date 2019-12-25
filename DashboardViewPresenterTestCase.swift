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
    func testgetAvatarShouldCallViewSetAvatarIfSuccess() {
        let view = FakeDashboardView()
        let accountManager = AccountManagerFake(result: .success("VigiClean".data(using: .utf8)!))
        let presenter = DashboardPresenter(accountManager: accountManager, view: view)
        
        presenter.getAvatar()
        
        XCTAssertTrue(view.didCallSetAvatar)
        XCTAssertFalse(view.didCallSendAlert)
    }
    
    func testgetAvatarShouldCallViewSendAlertIfFailure() {
        let view = FakeDashboardView()
        let accountManager = AccountManagerFake(result: .failure(EasyError()))
        let presenter = DashboardPresenter(accountManager: accountManager, view: view)
        
        presenter.getAvatar()
        
        XCTAssertTrue(view.didCallSendAlert)
        XCTAssertFalse(view.didCallSetAvatar)
    }
    
    func testgetAvatarShouldNotCallViewSendAlertIfFailureWithObjectNotFound() {
        let view = FakeDashboardView()
        let accountManager = AccountManagerFake(result: .failure(StorageErrorCode.objectNotFound))
        let presenter = DashboardPresenter(accountManager: accountManager, view: view)
        
        presenter.getAvatar()
        
        XCTAssertFalse(view.didCallSetAvatar)
        XCTAssertFalse(view.didCallSendAlert)
    }
}
