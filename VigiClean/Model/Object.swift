//
//  Object.swift
//  VigiClean
//
//  Created by Paul Leclerc on 03/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

// An object is managed by VigiClean.
class Object {
    
    // MARK: Properties
    let coords: GeoPoint
    let organization: String
    let type: String
    let name: String
    let code: String
    
    var actions: [Action]?
    var employeeActions: [Action]?
    
    init(coords: GeoPoint, organization: String, type: String, name: String, code: String) {
        self.coords = coords
        self.organization = organization
        self.type = type
        self.name = name
        self.code = code
    }
    
    init(coords: GeoPoint,
         organization: String,
         type: String,
         name: String,
         code: String,
         actions: [Action],
         employeeActions: [Action]) {
        self.coords = coords
        self.organization = organization
        self.type = type
        self.name = name
        self.code = code
        self.actions = actions
        self.employeeActions = employeeActions
    }
    
    static var currentObject: Object?
}
