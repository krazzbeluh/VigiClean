//
//  ScoreViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 31/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class ScoreViewPresenterTestCase: XCTestCase {
    var view: FakeScoreView!
    
    override func setUp() {
        self.view = FakeScoreView()
    }
    
    func testListenForUserDocumentChangesShouldCallValueChangedAtLeastOneTime() {
        let accountManager = AccountManagerFake()
        let presenter = ScoreViewPresenter(view: view, accountManager: accountManager)
        
        presenter.listenForUserCreditChange()
        
        XCTAssertTrue(view.didCallValueChanged)
    }
    
    func testGetColorCodeShouldReturn085_085_0_1IfEntryIs50() {
        let presenter = ScoreViewPresenter(view: view)
        
        let color = presenter.getColorCode(for: 50)
        
        XCTAssertEqual(color.red, 0.85)
        XCTAssertEqual(color.green, 0.85)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, 1)
    }
    
    func testGetColorCodeShouldReturn0_085_0_1IfEntryIs100() {
        let presenter = ScoreViewPresenter(view: view)
        
        let color = presenter.getColorCode(for: 100)
        
        XCTAssertEqual(color.red, 0)
        XCTAssertEqual(color.green, 0.85)
        XCTAssertEqual(color.blue, 0)
        XCTAssertEqual(color.alpha, 1)
    }
}
