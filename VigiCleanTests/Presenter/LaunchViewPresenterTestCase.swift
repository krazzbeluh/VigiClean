//
//  LaunchViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 14/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class LaunchViewPresenterTestCase: XCTestCase {
    var view: FakeLaunchView!
    
    override func setUp() {
        view = FakeLaunchView()
    }
    
    func testgetAvatarShouldNotCallGottenAvatarIfNoErrorButGetDocumentNotCalled() {
        let accountManager = AccountManagerFake()
        let presenter = LaunchPresenter(view: view, accountManager: accountManager)
        
        presenter.getAvatar()
        
        XCTAssertFalse(view.recievedAllResponses)
    }
    
    func testgetAvatarShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(errors: [EasyError()])
        let presenter = LaunchPresenter(view: view, accountManager: accountManager)
        
        presenter.getAvatar()
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
