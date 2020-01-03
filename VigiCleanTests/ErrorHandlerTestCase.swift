//
//  ErrorHandlerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 03/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class ErrorHandlerTestCase: XCTestCase {
    var errorHandler: ErrorHandler!
    
    override func setUp() {
        errorHandler = ErrorHandler()
    }
    
    func testConvertToAuthErrorShouldNotReturnNil() {
        let error = errorHandler.convertToAuthError(EasyError())
        XCTAssertNotNil(error)
    }
    
    func testConvertToStorageErrorShouldNotReturnNil() {
        let error = errorHandler.convertToStorageError(EasyError())
        XCTAssertNotNil(error)
    }
    
    func testConvertToFirestoreErrorShouldNotReturnNil() {
        let error = errorHandler.convertToFirestoreError(EasyError())
        XCTAssertNotNil(error)
    }
    
    func testConvertToFunctionsErrorShouldNotReturnNil() {
        let error = errorHandler.convertToFunctionsError(EasyError())
        XCTAssertNotNil(error)
    }
}
