//
//  SignUpViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class SignUpViewPresenterTestCase: XCTestCase {

    var view: FakeSignUpView!
    
    override func setUp() {
        view = FakeSignUpView()
    }
    
    func testSignUpShouldCallUserSignedInAndSwitchActivityIndicatorOneTimeIfNoError() {
        let accountManager = AccountManagerFake(error: nil)
        let presenter = SignUpPresenter(view: view, accountManager: accountManager)
        
        presenter.signUp(username: "username",
                         email: "email@vigiclean.com",
                         password: "1234567890",
                         confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallUserSignedUp)
        XCTAssertEqual(view.timesSwitchActivityIndicatorWasCalled, 1)
    }
    
    func testSignUpShouldCallDisplayErrorIfNoDataInStrings() {
        let presenter = SignUpPresenter(view: view)
        
        presenter.signUp(username: "",
                         email: "email@vigiclean.com",
                         password: "1234567890",
                         confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
        XCTAssertEqual(view.timesSwitchActivityIndicatorWasCalled, 0)
    }
    
    func testSignUpShouldCallDisplayErrorIfNoMatchingPasswords() {
        let presenter = SignUpPresenter(view: view)
        
        presenter.signUp(username: "username",
                         email: "email@vigiclean.com",
                         password: "0987654321",
                         confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
        XCTAssertEqual(view.timesSwitchActivityIndicatorWasCalled, 0)
    }

    func testSignUpShouldCallDisplayErrorAndSwitchActivityIndicatorTwoTimeIfError() {
        let accountManager = AccountManagerFake(error: EasyError())
        let presenter = SignUpPresenter(view: view, accountManager: accountManager)
        
        presenter.signUp(username: "username",
                         email: "email@vigiclean.com",
                         password: "1234567890",
                         confirmPassword: "1234567890")
        
        XCTAssertTrue(view.didCallDisplayError)
        XCTAssertEqual(view.timesSwitchActivityIndicatorWasCalled, 2)
    }
}
