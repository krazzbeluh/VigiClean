//
//  RequestViewPresenterTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 26/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
import FirebaseFirestore
import MapKit
@testable import VigiClean

class RequestViewPresenterTestCase: XCTestCase {
    let easyObject  = Object(coords: GeoPoint(latitude: 13, longitude: 42),
                             organization: "VigiClean",
                             type: "Type1",
                             name: "ObjectName",
                             code: "1234567890",
                             actions: [Action(index: 1, message: "UA1"), Action(index: 2, message: "UA2")],
                             employeeActions: [Action(index: 1, message: "EA1"), Action(index: 2, message: "EA2")])
    
    func testSwitchEmployeeMode() {
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.switchEmployeeMode(to: true)
        
        XCTAssertTrue(presenter.employeeMode)
    }
    
    func testActionsShouldReturnAutreIfNoObject() {
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        Object.currentObject = nil
        
        XCTAssertEqual(presenter.actions, ["Autre"])
    }
    
    func testActionsShouldNotBeTheSameIfEmployeeModeSwitched() {
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        let defaultMessage = "Autre"
        var uActionsString = easyObject.actions.map { $0.message }
        uActionsString.append(defaultMessage)
        var eActionsString = easyObject.employeeActions.map { $0.message }
        eActionsString.append(defaultMessage)
        
        Object.currentObject = Object(coords: GeoPoint(latitude: 0, longitude: 0),
                                      organization: "", type: "", name: "", code: "",
                                      actions: easyObject.actions,
                                      employeeActions: easyObject.employeeActions)
        
        XCTAssertEqual(presenter.actions, uActionsString)
        presenter.switchEmployeeMode(to: true)
        XCTAssertEqual(presenter.actions, eActionsString)
    }
    
    func testFetchRoleShouldReturnFalseCallbackIfFailure() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake(resultBool: .failure(EasyError()))
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.fetchRole { (isEmployee) in
            XCTAssertFalse(isEmployee)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testFetchRoleShouldReturnTrueCallbackIfSuccessTrue() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake(resultBool: .success(true))
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.fetchRole { (isEmployee) in
            XCTAssertTrue(isEmployee)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testPrepareMapShouldNotCallConfigureMapIfNoObject() {
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        Object.currentObject = nil
        
        presenter.prepareMap()
        
        XCTAssertNil(view.location)
    }
    
    func testPrepareMapShouldCallConfigureMapWithCorrecDatas() {
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        Object.currentObject = easyObject
        let object: Object! = Object.currentObject
        
        let poi = Poi(title: "\(object.name) - \(object.organization)",
            coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                               longitude: object.coords.longitude), info: object.type)
        
        presenter.prepareMap()
        
        XCTAssertNotNil(view.location)
        XCTAssertEqual(view.location?.title, poi.title)
        XCTAssertEqual(view.location?.coordinate.latitude, poi.coordinate.latitude)
        XCTAssertEqual(view.location?.coordinate.longitude, poi.coordinate.longitude)
        XCTAssertEqual(view.location?.info, poi.info)
    }
    
    func testSendRequestShouldReturnSuccessCallbackWithIsEmployeeAtTrueIfNoErrorAndIsEmployeeIsTrue() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: true)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.employeeActions.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true) { (result) in
            expectation.fulfill()
            switch result {
            case .success(let isEmployee):
                XCTAssertTrue(isEmployee)
            case .failure(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSendRequestShouldReturnFailureCallbackIfErrorAndIsEmployeeIsTrue() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: EasyError())
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: true)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.employeeActions.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true) { (result) in
            expectation.fulfill()
            switch result {
            case .success(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(true)
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSendRequestShouldReturnSuccessCallbackWithIsEmployeeAtFalseIfNoErrorAndIsEmployeeIsFalse() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: false)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.actions.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true) { (result) in
            expectation.fulfill()
            switch result {
            case .success(let isEmployee):
                XCTAssertFalse(isEmployee)
            case .failure(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
    
    func testSendRequestShouldReturnFailureCallbackIfErrorAndIsEmployeeIsFalse() {
        let expectation = XCTestExpectation(description: "Wait for callback")
        
        let view = FakeRequestView()
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(error: EasyError())
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: false)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.actions.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true) { (result) in
            expectation.fulfill()
            switch result {
            case .success(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(false)
            case .failure(_): // swiftlint:disable:this empty_enum_arguments
                XCTAssert(true)
            }
        }
        
        wait(for: [expectation], timeout: 0.01)
    }
}
