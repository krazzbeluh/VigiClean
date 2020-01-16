//
//  VigiCleanUserTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 12/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class VigiCleanUserTestCase: XCTestCase { // swiftlint:disable:this type_body_length
    override func setUp() {
        VigiCleanUser.currentUser = VigiCleanUser(username: "")
    }
    
    // MARK: isConnected
    func testIsConnectedShouldReturnTrueIfIsConnected() {
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "")
        VigiCleanUser.currentUser.auth = auth
        
        XCTAssertTrue(VigiCleanUser.currentUser.isConnected)
    }
    
    func testIsConnectedShouldReturnFalseIfIsNotConnected() {
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        VigiCleanUser.currentUser.auth = auth
        
        XCTAssertFalse(VigiCleanUser.currentUser.isConnected)
    }
    
    // MARK: isConnectedWithEmail
    func testIsConnectedWithEmailShouldReturnTrueIfIsConnectedWithEmail() {
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "", mail: "tester@vigiclean.com", errors: nil)
        
        VigiCleanUser.currentUser.auth = auth
        
        XCTAssertTrue(VigiCleanUser.currentUser.isConnectedWithEmail)
    }
    
    func testIsConnectedWithEmailShouldReturnFalseIfIsNotConnectedWithEmail() {
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "", mail: nil, errors: nil)
        VigiCleanUser.currentUser.auth = auth
        
        XCTAssertFalse(VigiCleanUser.currentUser.isConnectedWithEmail)
    }
    
    // MARK: Anonymous signIn
    func testAnonymousSignInShouldNotSendErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: nil, result: nil)
        
        VigiCleanUser.currentUser.anonymousSignIn { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testAnonymousSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: EasyError(), result: nil)
        
        VigiCleanUser.currentUser.anonymousSignIn { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignUp
    func testSignUpShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: nil, result: nil)
        
        VigiCleanUser.currentUser.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignUpShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: EasyError(), result: nil)
        
        VigiCleanUser.currentUser.signUp(username: "", email: "", password: "") { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignIn
    func testSignInShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: nil, result: nil)
        
        VigiCleanUser.currentUser.signIn(email: "", password: "") { error in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignInShouldReturnErrorCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        VigiCleanUser.currentUser.auth = AuthFake(error: EasyError(), result: nil)
        
        VigiCleanUser.currentUser.signIn(email: "", password: "") { (error) in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    // MARK: SignOut
    func testSignOutShouldNotReturnErrorCallbackIfSuccess() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = UserFake(uid: "", mail: "", errors: nil)
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.signOut { (error) in
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSignOutShouldReturnErrorCallbackIfFailure() {
        let auth = AuthFake(error: EasyError(), result: nil)
        auth.currentUser = UserFake(uid: "", mail: "", errors: nil)
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.signOut { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testSignOutShouldReturnSuccessCallbackIfNoErrorAndUserIsAnonymous() {
        let auth = AuthFake(error: nil, result: nil)
        let user = UserFake(uid: "", mail: "", errors: nil)
        user.email = nil
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.signOut { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSignOutShouldReturnErrorCallbackIfErrorAndUserIsAnonymous() {
        let auth = AuthFake(error: nil, result: nil)
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        user.email = nil
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.signOut { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: attachEmail
    func testAttachEmailShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.attachEmail(email: "", password: "") { error in
            XCTAssertNil(error)
        }
    }
    
    func testAttachEmailShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.attachEmail(email: "", password: "") { error in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: createPassword
    func testCreatePasswordShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.createPassword(password: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testCreatePasswordShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.createPassword(password: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updatePseudo
    func testUpdatePseudoShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        
        let database = FirestoreFake(errors: nil, datas: nil)
        
        VigiCleanUser.currentUser.auth = auth
        VigiCleanUser.currentUser.database = database
        
        VigiCleanUser.currentUser.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfFirestoreError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        
        let database = FirestoreFake(errors: [EasyError()], datas: nil)
        
        VigiCleanUser.currentUser.auth = auth
        VigiCleanUser.currentUser.database = database
        
        VigiCleanUser.currentUser.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfAuthError() {
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfUserNotLoggedInWithEmail() {
        let user = UserFake(uid: "", mail: nil, errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePseudoShouldReturnErrorCallbackIfUserNotLoggedIn() {
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = nil
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePseudo(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updateEmail
    func testUpdateEmailShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updateEmail(to: "", with: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfNoEmail() {
        let user = UserFake(uid: "", mail: nil, errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfErrorInReauthenticate() {
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdateEmailShouldReturnErrorCallbackIfErrorInUpdateEmail() {
        let user = UserFake(uid: "", mail: "", errors: [nil, EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updateEmail(to: "", with: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: updatePassword
    func testUpdatePasswordShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "", mail: "", errors: nil)
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePassword(to: "", from: "") { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testUpdatePasswordShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "", mail: "", errors: [EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePassword(to: "", from: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testUpdatePasswordShouldReturnErrorCallbackIfErrorAtUpdatePassword() {
        let user = UserFake(uid: "", mail: "", errors: [nil, EasyError()])
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        VigiCleanUser.currentUser.auth = auth
        
        VigiCleanUser.currentUser.updatePassword(to: "", from: "") { (error) in
            XCTAssertNotNil(error)
        }
    }
}
