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
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.switchEmployeeMode(to: true)
        
        XCTAssertTrue(presenter.employeeMode)
    }
    
    func testActionsShouldReturnAutreIfNoObject() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        Object.currentObject = nil
        
        XCTAssertEqual(presenter.actions, ["Autre"])
    }
    
    func testActionsShouldNotBeTheSameIfEmployeeModeSwitched() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        let defaultMessage = "Autre"
        var uActionsString = easyObject.actions!.map { $0.message }
        uActionsString.append(defaultMessage)
        var eActionsString = easyObject.employeeActions!.map { $0.message }
        eActionsString.append(defaultMessage)
        
        Object.currentObject = Object(coords: GeoPoint(latitude: 0, longitude: 0),
                                      organization: "", type: "", name: "", code: "",
                                      actions: easyObject.actions!,
                                      employeeActions: easyObject.employeeActions!)
        
        XCTAssertEqual(presenter.actions, uActionsString)
        presenter.switchEmployeeMode(to: true)
        XCTAssertEqual(presenter.actions, eActionsString)
    }
    
    func testPrepareMapShouldNotCallConfigureMapIfNoObject() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        Object.currentObject = nil
        
        presenter.prepareMap()
        
        XCTAssertNil(view.location)
    }
    
    func testPrepareMapShouldCallConfigureMapWithCorrecDatas() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
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
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
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
    
    func testSendRequestShouldReturnFailureCallbackIfErrorAndIsEmployeeIsTrue() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: true)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.employeeActions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertFalse(view.didCallRequestSent)
        XCTAssertNotNil(view.alert)
    }
    
    func testSendRequestShouldReturnSuccessCallbackWithIsEmployeeAtFalseIfNoErrorAndIsEmployeeIsFalse() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: nil)
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        presenter.switchEmployeeMode(to: false)
        Object.currentObject = easyObject
        
        guard let action = Object.currentObject?.actions!.first?.message else {
            XCTAssert(false)
            return
        }
        
        presenter.sendRequest(with: action, isValid: true)
        
        XCTAssertTrue(view.didCallRequestSent)
        XCTAssertNil(view.alert)
    }
    
    func testSendRequestShouldReturnFailureCallbackIfErrorAndIsEmployeeIsFalse() {
        let accountManager = AccountManagerFake()
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
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
    
    func testFetchRoleShouldCallRoleFetchedIfNoError() {
        let accountManager = AccountManagerFake(resultBool: .success(true))
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.fetchRole()
        
        XCTAssertTrue(view.didCallRoleFetched)
    }
    
    func testFetchRoleShouldCallRoleFetchedIfError() {
        let accountManager = AccountManagerFake(resultBool: .failure(EasyError()))
        let objectManager = ObjectManagerFake(errors: [EasyError()])
        let presenter = RequestPresenter(view: view, objectManager: objectManager, accountManager: accountManager)
        
        presenter.fetchRole()
        
        XCTAssertTrue(view.didCallRoleFetched)
    }
}
