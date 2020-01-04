//
//  FunctionsFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 23/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFunctions

class FunctionsFake: Functions {
    let error: Error?
    init(error: Error?) {
        self.error = error
    }
    
    override func httpsCallable(_ name: String) -> HTTPSCallable {
        return HTTPSCallableFake(error: error)
    }
}
