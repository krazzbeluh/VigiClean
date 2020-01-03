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
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.anonymousSignIn { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func  testAnonymousSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
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
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignUpShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
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
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.signIn(email: "", password: "") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
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
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.signOut { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.signOut { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: CreateUserDocument
    func testCreateUserDocumentShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        accountManager.createUserDocument(for: "", named: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCreateUserDocumentShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: EasyError(), data: nil))
        
        accountManager.createUserDocument(for: "", named: nil) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testGetUserInfosShouldReturnValueIfScoreData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        let data: [String: Any] = [
            "credits": 18
        ]
        
        XCTAssertEqual(try? accountManager.getUserInfos(in: data), 18)
    }
    
    func testGetUserInfosShouldNotReturnValueIfNoScoreData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        let data = [String: Any]()
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
    }
    
    func testGetUserInfosShouldStoreUsernameIfExists() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        let data: [String: Any] = [
            "username": "VigiClean"
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertEqual(AccountManager.currentUser.username, "VigiClean")
    }
    
    func testGetUserInfosShouldStoreRoleIfExists() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(error: nil, data: nil))
        
        let data: [String: Any] = [
            "isMaintainer": true
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertTrue(AccountManager.currentUser.isEmployee)
    }
}
