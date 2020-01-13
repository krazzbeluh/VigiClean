//
//  EmployeeViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import XCTest
@testable import VigiClean

class EmployeeViewPresenterTestCase: XCTestCase {
    func testGetObjectListShouldCallReloadTableViewIfNoError() {
        let view = FakeEmployeeView()
        let objectManager = ObjectManagerFake(errors: nil, data: nil)
        let presenter = EmployeePresenter(view: view, objectManager: objectManager)
        
        presenter.getObjectList()
        
        XCTAssertTrue(view.didCallReloadTableView)
    }
    
    func testGetObjectListShouldCallDisplayErrorIfError() {
        let view = FakeEmployeeView()
        let objectManager = ObjectManagerFake(errors: [EasyError()], data: nil)
        let presenter = EmployeePresenter(view: view, objectManager: objectManager)
        
        presenter.getObjectList()
        
        XCTAssertTrue(view.didCallDisplayError)
    }
}
