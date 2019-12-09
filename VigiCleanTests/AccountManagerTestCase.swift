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
    var accountManager: AccountManager!
    
    override func setUp() {
        accountManager = AccountManager()
    }
    
    func testAnonymousSignInShouldNotSendErrorCallbackIfSuccess() {
        accountManager.auth = AuthFake(error: nil, result: nil)
        accountManager.database = FirestoreFake(error: nil, documentSnapshot: nil)
        
        accountManager.anonymousSignIn { error in
            XCTAssertNil(error)
        }
    }

}
