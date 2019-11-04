//
//  VigiCleanUITests.swift
//  VigiCleanUITests
//
//  Created by Paul Leclerc on 04/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest

class VigiCleanUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
