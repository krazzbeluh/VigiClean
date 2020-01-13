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
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        let presenter = AttachEmailPresenter(view: view)
        
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
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testAttachEmailShouldCallDisplayErrorIfErrorAtUpdatePassword() {
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.attachEmail(username: "username",
                              email: "email@vigiclean.com",
                              password: "1234567890",
                              confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldCallUpdatedPseudoIfNoError() {
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.updatePseudo(username: "username", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallUpdatedPseudo)
    }
    
    func testUpdatePseudoShouldCallDisplayErrorIfNoDataInStrings() {
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.updatePseudo(username: "", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testUpdatePseudoShouldDisplayErrorIfError() {
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        let presenter = AttachEmailPresenter(view: view)
        
        presenter.updatePseudo(username: "username", password: "1234567890", confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
