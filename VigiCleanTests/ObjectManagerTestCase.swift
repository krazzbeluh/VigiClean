//
//  ObjectManagerTestCase.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 23/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import XCTest
import FirebaseFirestore
@testable import VigiClean

class ObjectManagerTestCase: XCTestCase {
    let easyObject  = Object(coords: GeoPoint(latitude: 13, longitude: 42),
                             organization: "VigiClean",
                             type: "Type1",
                             name: "ObjectName",
                             code: "1234567890")
    // MARK: getActions
    func testGetActionsShouldReturnSuccessCallbackAndStoreActionsIfNoErrors() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: [nil],
                                                                  data: ["1": "La poubelle est pleine"]),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssertNotNil(Object.currentObject?.actions)
                XCTAssertEqual(Object.currentObject?.actions?.first?.message, "La poubelle est pleine")
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testGetActionsShouldReturnFailureCallbackIfErrors() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: [EasyError()],
                                                                  data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            default:
                XCTAssertNil(Object.currentObject?.actions)
            }
        }
    }
    
    func testGetActionsShouldReturnFailureCallbackIfNoData() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil,
                                                                  data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            default:
                XCTAssertNil(Object.currentObject?.actions)
            }
        }
    }
    
    // MARK: GetEmployeeActions
    func testGetEmployeeActionsShouldReturnSuccessCallbackAndStoreEmployeeActionsIfNoErrors() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: ["1": "EmployeeAction"]),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getEmployeeActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssertNotNil(Object.currentObject?.employeeActions)
                XCTAssertEqual(Object.currentObject?.employeeActions?.first?.message, "EmployeeAction")
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testGetEmployeeActionsShouldReturnFailureCallbackIfErrors() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: [EasyError()], data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getEmployeeActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            default:
                XCTAssertNil(Object.currentObject?.employeeActions)
            }
        }
    }
    
    func testGetEmployeeActionsShouldReturnFailureCallbackIfNoData() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        
        objectManager.getEmployeeActions(for: Object.currentObject!) { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            default:
                XCTAssertNil(Object.currentObject?.employeeActions)
            }
        }
    }
    
    // MARK: getObject
    func testGetObjectShouldReturnSuccessCallbackAndStoreObjectIfNoError() {
        let data: [String: Any] = [
            "coords": GeoPoint(latitude: 1, longitude: 1),
            "name": "VigiClean",
            "organization": "VigiClean",
            "type": "Poubelle"
        ]
        
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: data),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = nil
        
        objectManager.getObject(code: "VigiClean") { (result) in
            switch result {
            case .success:
                XCTAssertNotNil(Object.currentObject)
            default:
                XCTAssert(false)
            }
        }
    }
    
    func testGetObjectShouldReturnFailureCallbackIfError() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: [EasyError()], data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = nil
        
        objectManager.getObject(code: "VigiClean") { (result) in
            switch result {
            case .success:
                XCTAssert(false)
            default:
                XCTAssertNil(Object.currentObject)
            }
        }
    }
    
    func testGetObjectShouldReturnFailureCallbackIfIncorectData() {
        let data: [String: Any] = [
            "name": "VigiClean",
            "organization": "VigiClean",
            "type": "Poubelle"
        ]
        
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: data),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = nil
        
        objectManager.getObject(code: "VigiClean") { (result) in
            switch result {
            case .failure(let error):
                if case FirebaseInterface.FIRInterfaceError.unableToDecodeData = error {
                    XCTAssert(true)
                } else {
                    XCTAssert(false)
                }
                XCTAssertNil(Object.currentObject)
            default:
                XCTAssert(false)
            }
        }
    }
    
    // MARK: sendRequest
    func testSendRequestShouldReturnSuccessCallbackIfNoError() {
        let user = UserFake(uid: "VigiClean User")
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: nil),
                                          functions: FunctionsFake(error: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = [Action(index: 1, message: "VigiClean Action")]
        
        objectManager.sendRequest(for: Object.currentObject!, with: Object.currentObject!.actions!.first!) { (error) in
            XCTAssertNil(error)
        }
    }
    
    func testSendRequestShouldReturnErrorCallbackIfError() {
        let user = UserFake(uid: "VigiClean User", errors: nil)
        let objectManager = ObjectManager(database: FirestoreFake(errors: [EasyError()], data: nil),
                                          functions: FunctionsFake(error: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = [Action(index: 1, message: "VigiClean Action")]
        
        objectManager.sendRequest(for: Object.currentObject!, with: Object.currentObject!.actions!.first!) { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    func testSendRequestShouldReturnErrorCallbackIfUserNotLoggedIn() {
        let user: UserFake? = nil
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: nil),
                                          functions: FunctionsFake(error: nil))
        
        let auth = AuthFake(error: nil, result: nil)
        auth.currentUser = user
        AccountManager.currentUser.auth = auth
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = [Action(index: 1, message: "VigiClean Action")]
        
        objectManager.sendRequest(for: Object.currentObject!, with: Object.currentObject!.actions!.first!) { (error) in
            XCTAssertNotNil(error)
        }
    }
    
    // MARK: resolvedRequest
    func testResolvedRequestShouldReturnSuccessCallbackIfNoError() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: nil),
                                          functions: FunctionsFake(error: nil))
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = [Action(index: 1, message: "VigiClean Action")]
        
        objectManager.resolvedRequest(for: Object.currentObject!,
                                      with: Object.currentObject!.actions!.first!,
                                      isValid: true) { (error) in
                                        XCTAssertNil(error)
        }
    }
    
    func testResolvedRequestShouldReturnErrorCallbackIfError() {
        let objectManager = ObjectManager(database: FirestoreFake(errors: nil, data: nil),
                                          functions: FunctionsFake(error: EasyError()))
        
        Object.currentObject = easyObject
        Object.currentObject?.actions = [Action(index: 1, message: "VigiClean Action")]
        
        objectManager.resolvedRequest(for: Object.currentObject!,
                                      with: Object.currentObject!.actions!.first!,
                                      isValid: true) { (error) in
                                        XCTAssertNotNil(error)
        }
    }
}
