//
//  ProfileViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class ProfileViewPresenterTestCase: XCTestCase {
    var view: FakeProfileView!
    
    override func setUp() {
        self.view = FakeProfileView()
    }
    
    func testIsConnectedAnonymouslyShouldReturnAccountManagerIsConnectedWithEmailInverted() {
        let accountManager = AccountManagerFake()
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        accountManager.isConnectedWithEmail = false
        
        XCTAssertTrue(presenter.isConnectedAnonymously)
        
        accountManager.isConnectedWithEmail = true
        
        XCTAssertFalse(presenter.isConnectedAnonymously)
    }
    
    func testSignOutShouldCallUserSignedOutIfNoError() {
        let accountManager = AccountManagerFake(error: nil)
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.signOut()
        
        XCTAssertTrue(view.didCallUserSignedOut)
    }
    
    func testSignOutShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(error: EasyError())
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.signOut()
        
        XCTAssertFalse(view.didCallUserSignedOut)
    }
    
    func testUpdatePseudoShouldCallDisplayUsernameIfNoError() {
        let accountManager = AccountManagerFake(error: nil)
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updatePseudo(to: "username", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayUsername)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(error: EasyError())
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updatePseudo(to: "username", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfEmptyTextField() {
        let accountManager = AccountManagerFake(error: EasyError())
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updatePseudo(to: "", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateEmailShouldCallDisplayEmailIfNoError() {
        let accountManager = AccountManagerFake(error: nil)
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updateEmail(to: "email@vigiclean.com", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayEmail)
    }
    
    func testUpdateEmailShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(error: EasyError())
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updateEmail(to: "email@vigiclean.com", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdateEmailShouldCallDisplayErrorIfNilInTextField() {
        let accountManager = AccountManagerFake(error: nil)
        let presenter = ProfilePresenter(view: view, accountManager: accountManager)
        
        presenter.updateEmail(to: "", with: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
