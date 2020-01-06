//
//  AttachEmailViewPresenterTestCaase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class AttachEmailViewPresenterTestCaase: XCTestCase {
    var view: FakeAttachEmailView!
    
    override func setUp() {
        self.view = FakeAttachEmailView()
    }
    
    func testAttachEmailShouldCallEmailAttachedIfNoError() {
        let accountManager = AccountManagerFake(errors: [nil, nil])
        let presenter = AttachEmailPresenter(view: view, accountManager: accountManager)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallAttachedEmail)
    }
    
    func testAttachEmailShouldCallDisplayErrorIfNoDataInStrings() {
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "0987654321")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testAttachEmailShouldCallDisplayErrorIfNotMatchingPasswords() {
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.attachEmail(username: "",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testAttachEmailShouldCallDisplayErrorIfError() {
        let accountManager = AccountManagerFake(errors: [EasyError()])
        let presenter = AttachEmailPresenter(view: view, accountManager: accountManager)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testAttachEmailShouldCallDisplayErrorIfErrorAtUpdatePassword() {
        let accountManager = AccountManagerFake(errors: [nil, EasyError()])
        let presenter = AttachEmailPresenter(view: view, accountManager: accountManager)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldCallUpdatedPseudoIfNoError() {
        let accountManager = AccountManagerFake(errors: [nil])
        let presenter = AttachEmailPresenter(view: view, accountManager: accountManager)
        
        presenter.updatePseudo(username: "username", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallUpdatedPseudo)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfNoDataInStrings() {
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.updatePseudo(username: "", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldDisplayErrorIfError() {
        let accountManager = AccountManagerFake(errors: [EasyError()])
        let presenter = AttachEmailPresenter(view: view, accountManager: accountManager)
        
        presenter.updatePseudo(username: "username", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
