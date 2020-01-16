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
    var view: FakeRequestView!
    let easyObject  = Object(coords: GeoPoint(latitude: 13, longitude: 42),
                             organization: "VigiClean",
                             type: "Type1",
                             name: "ObjectName",
                             code: "1234567890",
                             actions: [Action(index: 1, message: "UA1"), Action(index: 2, message: "UA2")],
                             employeeActions: [Action(index: 1, message: "EA1"), Action(index: 2, message: "EA2")])
    
    override func setUp() {
        view = FakeRequestView()
    }
    
    func testSwitchEmployeeMode() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
        presenter.switchEmployeeMode(to: true)
        
        XCTAssertTrue(presenter.employeeMode)
    }
    
    func testActionsShouldReturnEmptyArrayIfNoObject() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
        Object.currentObject = nil
        
        XCTAssertEqual(presenter.actions, [String]())
    }
    
    func testActionsShouldReturnEmptyArrayAndCallDisplayErrorIfNoActions() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = nil
        
        XCTAssertEqual(presenter.actions, [String]())
        XCTAssertNotNil(view.alert)
    }

    func testActionsShouldReturnEmptyArrayAndCallDisplayErrorIfNoActionsAndUserIsEmployee() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        presenter.employeeMode = true
        
        Object.currentObject = easyObject
        Object.currentObject?.employeeActions = nil
        
        XCTAssertEqual(presenter.actions, [String]())
        XCTAssertNotNil(view.alert)
    }
    
    func testActionsShouldNotBeTheSameIfEmployeeModeSwitched() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
        let uActionsString = easyObject.actions!.map { $0.message }
        let eActionsString = easyObject.employeeActions!.map { $0.message }
        
        Object.currentObject = Object(coords: GeoPoint(latitude: 0, longitude: 0),
                                      organization: "", type: "", name: "", code: "",
                                      actions: easyObject.actions!,
                                      employeeActions: easyObject.employeeActions!)
        
        XCTAssertEqual(presenter.actions, uActionsString)
        presenter.switchEmployeeMode(to: true)
        XCTAssertEqual(presenter.actions, eActionsString)
    }
    
    func testPrepareMapShouldNotCallConfigureMapIfNoObject() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
        Object.currentObject = nil
        
        presenter.prepareMap()
        
        XCTAssertNil(view.location)
    }
    
    func testPrepareMapShouldCallConfigureMapWithCorrecDatas() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        
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
    
    func testSendRequestShouldCallRequestSentWithIsEmployeeAtTrueIfNoErrorAndIsEmployeeIsTrue() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        presenter.switchEmployeeMode(to: true)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.employeeActions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertTrue(view.didCallRequestSent)
        XCTAssertNil(view.alert)
    }
    
    func testSendRequestShouldCallSendAlertIfErrorAndIsEmployeeIsTrue() {
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        presenter.switchEmployeeMode(to: true)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.employeeActions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertTrue(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallRequestSentWithIsEmployeeAtFalseIfNoErrorAndIsEmployeeIsFalse() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        presenter.switchEmployeeMode(to: false)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.actions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertTrue(view.didCallRequestSent)
        XCTAssertFalse(view.employeeMode ?? true)
        XCTAssertNil(view.alert)
    }
    
    func testSendRequestShouldCallRequestSentIfErrorAndIsEmployeeIsFalse() {
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        presenter.switchEmployeeMode(to: false)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.actions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallDisplayErrorIfNoObject() {
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager)
        Object.currentObject = nil
        
        presenter.sendRequest(with: "", isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallDisplayErrorIfNoActions() {
        Object.currentObject = easyObject
        Object.currentObject?.actions = nil
        let presenter = RequestPresenter(view: view)
        
        presenter.sendRequest(with: "", isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallDisplayErrorIfNoActionsAndUserIsEmployed() {
        Object.currentObject = easyObject
        Object.currentObject?.employeeActions = nil
        let presenter = RequestPresenter(view: view)
        presenter.switchEmployeeMode(to: true)
        
        presenter.sendRequest(with: "", isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallDisplayErrorIfInvalidAction() {
        Object.currentObject = easyObject
        let presenter = RequestPresenter(view: view)
        
        presenter.sendRequest(with: "", isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldCallDisplayErrorIfInvalidActionAndUserIsEmployed() {
        Object.currentObject = easyObject
        let presenter = RequestPresenter(view: view)
        presenter.switchEmployeeMode(to: true)
        
        presenter.sendRequest(with: "", isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
}
