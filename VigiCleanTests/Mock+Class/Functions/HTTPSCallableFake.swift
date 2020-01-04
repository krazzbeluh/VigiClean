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
    
    init(error: Error?) {
        self.error = error
    }
    
    override func call(completion: @escaping (HTTPSCallableResult?, Error?) -> Void) {
        completion(nil, error)
    }
}
