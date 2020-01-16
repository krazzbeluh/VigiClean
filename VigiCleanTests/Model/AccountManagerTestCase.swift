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
    
    // MARK: CreateUserDocument
    func testCreateUserDocumentShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        accountManager.createUserDocument(for: "", named: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCreateUserDocumentShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(database: FirestoreFake(errors: [EasyError()], datas: nil))
        
        accountManager.createUserDocument(for: "", named: nil) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: getUserInfos
    func testGetUserInfosShouldReturnValueIfScoreData() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data: [String: Any] = [
            "credits": 18
        ]
        
        accountManager.getUserInfos(in: data)
        
        XCTAssertEqual(VigiCleanUser.currentUser.credits, 18)
    }
    
    func testGetUserInfosShouldStoreUsernameIfExists() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data: [String: Any] = [
            "username": "VigiClean"
        ]
        
        accountManager.getUserInfos(in: data)
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
    }
    
    func testGetUserInfosShouldStoreRoleIfExists() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data: [String: Any] = [
            "employedAt": "VigiClean"
        ]
        
        accountManager.getUserInfos(in: data)
        XCTAssertTrue(VigiCleanUser.currentUser.isEmployee)
    }
    
    // MARK: listenForUserDocumentChanges
    func testListenForUserDocumentChangesShouldStoreCreditsIfNoError() {
        let credits = Int.random(in: 1 ... 100)
        
        let data: [String: Any] = [
            "credits": credits
        ]

        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: [data]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges {
            XCTAssertEqual(credits, VigiCleanUser.currentUser.credits)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfUserNotLoggedIn() {
        let accountManager = AccountManager(database: FirestoreFake(errors: [EasyError()], datas: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges {
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoData() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges {
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsButStoreDatasIfNoCreditsInData() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: [[
                                                "username": "VigiClean"
                                            ]]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges {}
        
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoCreditsInDataIfCallback() {
        VigiCleanUser.currentUser.credits = 0
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: [[
                                                "username": "VigiClean"
                                            ]]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges {}
        
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
        XCTAssertEqual(VigiCleanUser.currentUser.credits, 0)
    }
}
