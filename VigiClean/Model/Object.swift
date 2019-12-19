//
//  Object.swift
//  VigiClean
//
//  Created by Paul Leclerc on 03/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Object {
    
    // MARK: Properties
    let coords: GeoPoint
    let organization: String
    let type: String
    let name: String
    let code: String
    
    let actions: [Action]
    let employeeActions: [Action]
    
    static var currentObject: Object?
}
