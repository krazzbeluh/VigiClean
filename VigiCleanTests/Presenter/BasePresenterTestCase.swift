//
//  BasePresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 16/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class BasePresenterTestCase: XCTestCase {
    let defaultMessage = "Une erreur est survenue, veuillez réessayer ultérieurement."
    var presenter: BasePresenter!
    
    override func setUp() {
        presenter = BasePresenter()
    }
    
    func testErrorHandlerErrorShouldReturnDefaultMessage() {
        let message = presenter.convertError(ErrorHandler.Errors.canNotConvertError)
        
        XCTAssertEqual(message, defaultMessage)
    }
    
    func testUserDocumentNtCreatedShouldReturnDefaultMessage() {
        let message = presenter.convertError(AccountManager.UAccountError.userDocumentNotCreated)
        
        XCTAssertEqual(message, defaultMessage)
    }
    
    func testNtEnoughCreditsShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(AccountManager.UAccountError.notEnoughCredits)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testUserNotLoggedInShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(AccountManager.UAccountError.userNotLoggedIn)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testUserNotLoggedInWithEmailShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(AccountManager.UAccountError.userNotLoggedInWithEmail)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testNotMatchingPasswordShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(AccountManager.UAccountError.notMatchingPassword)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    // MARK: ScannerError
    func testScanNotSupportedShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(ScannerError.scanNotSupported)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testInvalidQRCodeShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(ScannerError.invalidQRCode)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    // MARK: UserError
    func testNilInTextFieldShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(UserError.nilInTextField)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testPasswordMismatchesShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(UserError.passwordMismatches)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testUnWantedValuesShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(UserError.unWantedValues)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    // MARK: ObjectError
    func testOMUserNotLoggedInShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(ObjectManager.ObjectError.userNotLoggedIn)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testActionNotFoundInShouldReturnDefaultMessage() {
        let message = presenter.convertError(ObjectManager.ObjectError.actionNotFound)
        
        XCTAssertEqual(message, defaultMessage)
    }
    
    func testNotEmployedUserShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(ObjectManager.ObjectError.notEmployedUser)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    // MARK: FirebaseInterface
    func testDocumentDsNtExistsShouldNotReturnDefaultMessage() {
        let message = presenter.convertError(FirebaseInterfaceError.documentDoesNotExists)
        
        XCTAssertNotEqual(message, defaultMessage)
    }
    
    func testUnableToDecodeDataShouldReturnDefaultMessage() {
        let message = presenter.convertError(FirebaseInterfaceError.unableToDecodeData)
        
        XCTAssertEqual(message, defaultMessage)
    }
}
