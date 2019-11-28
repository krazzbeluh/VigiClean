//
//  UserAccountTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

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
        UserAccount.auth = FakeAuth(result: nil, error: UserAccount.UAccountError.userDocumentNotCreated)
        UserAccount.anonymousSignIn { error in
            print(error)
            XCTAssertNotNil(error)
        }
        
        XCTAssertTrue(UserAccount.isConnected)
        XCTAssertFalse(UserAccount.isConnectedWithEmail)
    }
}
