//
//  WelcomeViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class WelcomeViewPresenterTestCase: XCTestCase {
    var view: FakeWelcomeView!
    
    override func setUp() {
        self.view = FakeWelcomeView()
    }
    
    func testSignInShouldCallPerformSegueIfNoError() {
        let accountManager = AccountManagerFake(errors: [nil])
        let presenter = WelcomePresenter(view: view, accountManager: accountManager)
        
        presenter.signIn()
        
        XCTAssertTrue(view.didCallPerformSegue)
    }
    
    func testSignInShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(errors: [EasyError()])
        let presenter = WelcomePresenter(view: view, accountManager: accountManager)
        
        presenter.signIn()
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
