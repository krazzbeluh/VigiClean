//
//  SignInViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class SignInViewPresenterTestCase: XCTestCase {
    var view: FakeSignInView!
    
    override func setUp() {
        self.view = FakeSignInView()
    }
    
    func testSignInShouldCallUserSignedInIfNoError() {
        let accountManager = AccountManagerFake(resultData: .success(Data()))
        let presenter = SignInPresenter(view: view, accountManager: accountManager)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: nil)
        
        presenter.signIn(email: "email@vigiclean.com", password: "1234567890")
        
        XCTAssertTrue(view.didCallUserSignedIn)
    }
    
    func testSignInShouldCallDisplayErrorIfError() {
        let presenter = SignInPresenter(view: view)
        
        VigiCleanUser.currentUser = VigiCleanUserFake(username: "", error: EasyError())
        
        presenter.signIn(email: "email@vigiclean.com", password: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
    
    func testSignInShouldCallDisplayErrorIfNilInTextField() {
        let accountManager = AccountManagerFake(errors: [nil])
        let presenter = SignInPresenter(view: view, accountManager: accountManager)
        
        presenter.signIn(email: "", password: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
