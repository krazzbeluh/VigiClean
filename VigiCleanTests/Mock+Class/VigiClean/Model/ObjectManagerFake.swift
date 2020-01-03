//
//  ObjectManagerFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 26/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
@testable import VigiClean

class ObjectManagerFake: ObjectManager {
    let error: Error?
    
    init(error: Error?) {
        self.error = error
        super.init(database: FirestoreFake(error: error, data: nil), functions: FunctionsFake(error: error))
    }
    
    override func resolvedRequest(for object: Object,
                                  with action: Action,
                                  isValid: Bool,
                                  callback: @escaping (Error?) -> Void) {
        callback(error)
    }
    
    override func sendRequest(for object: Object,
                              with action: Action,
                              callback: @escaping (Error?) -> Void) {
        callback(error)
    }
    
    override func getObject(code: String, callback: @escaping (Result<Void, Error>) -> Void) {
        if let error = error {
            callback(.failure(error))
        } else {
            callback(.success(Void()))
        }
    }
}
