//
//  HTTPSCallableFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 04/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFunctions
@testable import VigiClean

class HTTPSCallableFake: HTTPSCallable {
    let error: Error?
    let data: Any?
    
    init(error: Error?, data: Any?) {
        self.error = error
        self.data = data
    }
    
    override func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void) {
        if let data = data {
            completion(HTTPSCallableResultFake(data: data), error)
        } else {
            completion(nil, error)
        }
        
    }
}
