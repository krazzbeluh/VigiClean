//
//  AccountManagerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class AccountManagerTestCase: XCTestCase {
    override func setUp() {
    }
    
    // MARK: Anonymous signIn
    func testAnonymousSignInShouldNotSendErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.anonymousSignIn { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func  testAnonymousSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.anonymousSignIn { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignUp
    func testSignUpShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignUpShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignIn
    func testSignInShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signIn(email: "", password: "") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signIn(email: "", password: "") { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignOut
    
    func testSignOutShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signOut { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, documentSnapshot: nil))
        
        accountManager.signOut { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
