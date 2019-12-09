//
//  Object.swift
//  VigiClean
//
//  Created by Paul Leclerc on 03/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class Object {
    
    // MARK: Properties
    let coords: GeoPoint
    let organization: String
    let type: String
    let name: String
    let code: String
    
    let actions: [String]
    
    init(coords: GeoPoint, organization: String, type: String, name: String, code: String, actions: [String]) {
        self.coords = coords
        self.organization = organization
        self.type = type
        self.name = name
        self.code = code
        self.actions = actions
    }
    
    static var currentObject: Object?
}
