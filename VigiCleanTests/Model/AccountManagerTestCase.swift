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
        
        XCTAssertEqual(try? accountManager.getUserInfos(in: data), 18)
    }
    
    func testGetUserInfosShouldNotReturnValueIfNoScoreData() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data = [String: Any]()
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
    }
    
    func testGetUserInfosShouldStoreUsernameIfExists() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data: [String: Any] = [
            "username": "VigiClean"
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
    }
    
    func testGetUserInfosShouldStoreRoleIfExists() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let data: [String: Any] = [
            "employedAt": "VigiClean"
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertTrue(VigiCleanUser.currentUser.isEmployee)
    }
    
    // MARK: listenForUserDocumentChanges
    func testListenForUserDocumentChangesShouldReturnCreditsIfNoError() {
        let credits = Int.random(in: 1 ... 100)
        
        let data: [String: Any] = [
            "credits": credits
        ]

        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: [data]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        var listenedCredits = 0
        
        accountManager.listenForUserDocumentChanges { (credits) in
            listenedCredits = credits
        }
        
        XCTAssertEqual(credits, listenedCredits)
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfError() {
        let accountManager = AccountManager(database: FirestoreFake(errors: [EasyError()], datas: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfUserNotLoggedIn() {
        let accountManager = AccountManager(database: FirestoreFake(errors: [EasyError()], datas: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoData() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
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
        
        accountManager.listenForUserDocumentChanges(creditsChanged: nil)
        
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoCreditsInDataIfCallback() {
        let accountManager = AccountManager(database: FirestoreFake(errors: nil, datas: [[
                                                "username": "VigiClean"
                                            ]]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
        
        XCTAssertEqual(VigiCleanUser.currentUser.username, "VigiClean")
    }
}
