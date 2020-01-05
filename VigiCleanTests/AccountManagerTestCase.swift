//
//  AccountManagerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class AccountManagerTestCase: XCTestCase { // swiftlint:disable:this type_body_length
    override func setUp() {
    }
    
    // MARK: isConnected
    func testIsConnectedShouldReturnTrueIfIsConnected() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        XCTAssertTrue(accountManager.isConnected)
    }
    
    func testIsConnectedShouldReturnFalseIfIsNotConnected() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        AccountManager.currentUser.auth = auth
        
        XCTAssertFalse(accountManager.isConnected)
    }
    
    // MARK: isConnectedWithEmail
    func testIsConnectedWithEmailShouldReturnTrueIfIsConnectedWithEmail() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "", mail: "", errors: nil)
        AccountManager.currentUser.auth = auth
        
        XCTAssertTrue(accountManager.isConnectedWithEmail)
    }
    
    func testIsConnectedWithEmailShouldReturnFalseIfIsNotConnectedWithEmail() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "", mail: nil, errors: nil)
        AccountManager.currentUser.auth = auth
        
        XCTAssertFalse(accountManager.isConnectedWithEmail)
    }
    
    // MARK: Anonymous signIn
    func testAnonymousSignInShouldNotSendErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.anonymousSignIn { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func  testAnonymousSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
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
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignUpShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
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
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.signIn(email: "", password: "") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
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
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.signOut { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: EasyError(), result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
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
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.createUserDocument(for: "", named: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testCreateUserDocumentShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: [EasyError()], data: nil))
        
        accountManager.createUserDocument(for: "", named: nil) { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: getUserInfos
    func testGetUserInfosShouldReturnValueIfScoreData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let data: [String: Any] = [
            "credits": 18
        ]
        
        XCTAssertEqual(try? accountManager.getUserInfos(in: data), 18)
    }
    
    func testGetUserInfosShouldNotReturnValueIfNoScoreData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let data = [String: Any]()
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
    }
    
    func testGetUserInfosShouldStoreUsernameIfExists() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let data: [String: Any] = [
            "username": "VigiClean"
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertEqual(AccountManager.currentUser.username, "VigiClean")
    }
    
    func testGetUserInfosShouldStoreRoleIfExists() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let data: [String: Any] = [
            "isMaintainer": true
        ]
        
        XCTAssertNil(try? accountManager.getUserInfos(in: data))
        XCTAssertTrue(AccountManager.currentUser.isEmployee)
    }
    
    // MARK: attachEmail
    func testAttachEmailShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.attachEmail(email: "", password: "") { error in
            XCTAssertNil(error)
        }
    }
    
    func testAttachEmailShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.attachEmail(email: "", password: "") { error in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updatePassword
    func testUpdatePasswordShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updatePassword(password: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdatePasswordShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updatePassword(password: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updatePseudo
    func testUpdatePseudoShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfFirestoreError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: [EasyError()], data: nil))
        
        accountManager.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfAuthError() {
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfUserNotLoggedInWithEmail() {
        let user = UserFake(uid: "", mail: nil, errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updateEmail
    func testUpdateEmailShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updateEmail(to: "", with: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfNoEmail() {
        let user = UserFake(uid: "", mail: nil, errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfErrorInReauthenticate() {
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfErrorInUpdateEmail() {
        let user = UserFake(uid: "", mail: "", errors: [nil, EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        accountManager.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: listenForUserDocumentChanges
    func testListenForUserDocumentChangesShouldReturnCreditsIfNoError() {
        let credits = Int.random(in: 1 ... 100)
        
        let data: [String: Any] = [
            "credits": credits
        ]

        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: data))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        var listenedCredits = 0
        
        accountManager.listenForUserDocumentChanges { (credits) in
            listenedCredits = credits
        }
        
        XCTAssertEqual(credits, listenedCredits)
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfError() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: [EasyError()], data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfUserNotLoggedIn() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: [EasyError()], data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        AccountManager.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsButStoreDatasIfNoCreditsInData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: [
                                                "username": "VigiClean"
                                            ]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges(creditsChanged: nil)
        
        XCTAssertEqual(AccountManager.currentUser.username, "VigiClean")
    }
    
    func testListenForUserDocumentChangesShouldNotReturnCreditsIfNoCreditsInDataIfCallback() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: [
                                                "username": "VigiClean"
                                            ]))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.listenForUserDocumentChanges { (_) in
            XCTAssert(false)
        }
        
        XCTAssertEqual(AccountManager.currentUser.username, "VigiClean")
    }
    
    // MARK: fetchRole
    func testFetchRoleShouldReturnSuccessCallbackIfNoError() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: [
                                                "isMaintainer": false
                                            ]))
        
        let auth =  AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.fetchRole { (result) in
            switch result {
            case .success:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchRoleShouldReturnFailureCallbackIfUserNotLoggedIn() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: [
                                                "isMaintainer": false
                                            ]))
        
        let auth =  AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        AccountManager.currentUser.auth = auth
        
        accountManager.fetchRole { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchRoleShouldReturnFailureCallbackIfError() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: [EasyError()], data: nil))
        
        let auth =  AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.fetchRole { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testFetchRoleShouldReturnFailureCallbackIfIncorrectData() {
        let accountManager = AccountManager(auth: AuthFake(error: nil, result: nil),
                                            database: FirestoreFake(errors: nil, data: [
                                                "App": "VigiClean"
                                            ]))
        
        let auth =  AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        AccountManager.currentUser.auth = auth
        
        accountManager.fetchRole { (result) in
            switch result {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false)
            }
        }
    }
    
} // swiftlint:disable:this file_length
