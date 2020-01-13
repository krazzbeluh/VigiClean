//
//  ObjectManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 26/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import VigiClean

class ObjectManagerFake: ObjectManager {
    var errors: [Error?]?
    let data: [String: Any]?
    
    init(errors: [Error?]?, data: [String: Any]? = nil) {
        self.errors = errors
        self.data = data
        super.init(database: FirestoreFake(errors: errors, data: nil), functions: FunctionsFake(error: nil, data: nil))
    }
    
    override func resolvedRequest(for object: Object,
                                  with action: Action,
                                  isValid: Bool,
                                  callback: @escaping (Error?) -> Void) {
        callback(getNextError())
    }
    
    override func sendRequest(for object: Object,
                              with action: Action,
                              callback: @escaping (Error?) -> Void) {
        callback(getNextError())
    }
    
    override func getObject(code: String, callback: @escaping (Result<Object, Error>) -> Void) {
        if let error = getNextError() {
            callback(.failure(error))
        } else {
            callback(.success(Object(coords: GeoPoint(latitude: 1, longitude: 1),
                                     organization: "VigiClean",
                                     type: "",
                                     name: "",
                                     code: "")))
        }
    }
    
    override func getActions(for object: Object, callback: @escaping (Result<Void, Error>) -> Void) {
        if let error = getNextError() {
            callback(.failure(error))
        } else {
            callback(.success(Void()))
        }
    }
    
    override func getEmployeeActions(for object: Object, callback: @escaping (Result<Void, Error>) -> Void) {
        if let error = getNextError() {
            callback(.failure(error))
        } else {
            callback(.success(Void()))
        }
    }
    
    override func getObjectList(callback: @escaping (Result<[Object], Error>) -> Void) {
        if let error = getNextError() {
            callback(.failure(error))
        } else {
            callback(.success([Object]()))
        }
    }
    
    private func getNextError() -> Error? {
        guard let error = errors?.first else {
            return nil
        }
        
        errors?.removeFirst()
        
        return error
    }
}
