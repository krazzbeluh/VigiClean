//
//  HTTPSCallableResultFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFunctions

class HTTPSCallableResultFake: HTTPSCallableResult {
    private let dataContained: Any
    
    init(data: Any) {
        dataContained = data
    }
    
    override var data: Any {
        return dataContained
    }
}
