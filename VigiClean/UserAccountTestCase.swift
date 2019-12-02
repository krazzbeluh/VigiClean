//
//  UserAccountTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

struct EasyError: Error {}

import XCTest
import FirebaseAuth
@testable import VigiClean

class UserAccountTestCase: XCTestCase {
    
    override func setUp() {
    }

    // MARK: Anonymous Sign In
    func testAnonymousSignInShouldntReturnErrorIfSuccess() {
        UserAccount.auth = FakeAuth(result: nil, error: nil)
        UserAccount.anonymousSignIn { error in
            XCTAssertNil(error)
        }
        
        XCTAssertTrue(UserAccount.isConnected)
        XCTAssertFalse(UserAccount.isConnectedWithEmail)
    }
    
    func testAnonymousSignInShouldReturnErrorIfNotSuccess() {
        UserAccount.auth = FakeAuth(result: nil, error: EasyError())
        // TODO: Use Firebase Errors
        UserAccount.anonymousSignIn { error in
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(UserAccount.isConnected)
        XCTAssertFalse(UserAccount.isConnectedWithEmail)
    }
    
    // MARK: Sign Up
    func testSignUpShouldntReturnErrorIfSuccess() {
        UserAccount.auth = FakeAuth(result: FakeAuthDataResult(user: FakeUser(mail: nil,
                                                                              identifier: "signedUpUser")),
                                    error: nil)
        UserAccount.database = FakeFirestore.init(error: nil)
        
        UserAccount.signUp(username: "Username", email: "Email", password: "Password") { error in
            XCTAssertNil(error)
        }
        
        XCTAssertTrue(UserAccount.isConnected)
        XCTAssertTrue(UserAccount.isConnectedWithEmail)
    }
    
    func testSignUpShouldReturnErrorIfNotSuccess() {
        UserAccount.auth = FakeAuth(result: FakeAuthDataResult(user: FakeUser(mail: nil,
                                                                              identifier: "signedUpUser")),
                                    error: EasyError())
        UserAccount.database = FakeFirestore.init(error: nil)
        
        UserAccount.signUp(username: "Username", email: "Email", password: "Password") { error in
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(UserAccount.isConnected)
        XCTAssertTrue(UserAccount.isConnectedWithEmail)
    }
}
