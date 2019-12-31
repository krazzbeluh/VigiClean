//
//  ScannerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 30/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class ScannerViewPresenterTestCase: XCTestCase {
    var view: FakeScannerView!
    
    override func setUp() {
        view = FakeScannerView()
    }
    
    func testObjectCodeReturnsCodeAndRemovesURL() {
        let presenter = ScannerPresenter(view: view)
        presenter.lastCode = "https://www.vigiclean.com/?code=1234567890"
        
        XCTAssertEqual(presenter.objectCode, "1234567890")
    }

    func testVerifyCodeShouldCallCorrectCodeFoundIfNoError() {
        let presenter = ScannerPresenter(view: view)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=1234567890")
        
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 1)
    }
    
    func testVerifyCodeShouldCallCorrectCodeFoundOnlyOneTimeIfTestingTheSameCode() {
        let presenter = ScannerPresenter(view: view)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=1234567890")
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 1)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=1234567890")
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 1)
    }
    
    func testVerifyCodeShouldCallCorrectCodeFound3TimesIfTesting2CodesAlternatively() {
        let presenter = ScannerPresenter(view: view)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=1234567890")
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 1)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=AZERTYUIOP")
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 2)
        presenter.verifyCode(code: "https://www.vigiclean.com/?code=1234567890")
        XCTAssertEqual(view.correctCodeFoundWasCalledXTimes, 3)
    }
    
    func testVerifyCodeShouldCallInvalidCodeVoundIfError() {
        let presenter = ScannerPresenter(view: view)
        presenter.verifyCode(code: "")
        XCTAssertTrue(view.didCallInvalidCodeFound)
    }
    
    func testGetObjectShouldCallValidObjectFoundIfNoError() {
        let presenter = ScannerPresenter(view: view, objectManager: ObjectManagerFake(error: nil))
        presenter.lastCode = "https://www.vigiclean.com/?code=1234567890"
        
        presenter.getObject()
        
        XCTAssertTrue(view.didCallValidObjectFound)
        XCTAssertFalse(view.didCallInvalidCodeFound)
    }
    
    func testGetObjectShouldCallInvalidCodeFoundIfError() {
        let presenter = ScannerPresenter(view: view, objectManager: ObjectManagerFake(error: EasyError()))
        presenter.lastCode = "https://www.vigiclean.com/?code=1234567890"
        
        presenter.getObject()
        
        XCTAssertFalse(view.didCallValidObjectFound)
        XCTAssertTrue(view.didCallInvalidCodeFound)
    }
}
