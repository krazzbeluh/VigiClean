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
    
    private init(coords: GeoPoint, organization: String, type: String, name: String, code: String) {
        self.coords = coords
        self.organization = organization
        self.type = type
        self.name = name
    }
    
    static var currentObject: Object?
    
    static func getObject(code: String, callback: @escaping (Error?) -> Void) {
        // TODO: call firebase firestore
        let docRef = FirebaseInterface.database.collection("Object").document(code)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                callback(error)
                return
            }
            
            guard let data = document.data(),
                let coords = data["coords"] as? GeoPoint,
                let organization = data["organization"] as? String,
                let type = data["type"] as? String,
                let name = data["name"] as? String else {
                    callback(FirebaseInterface.FIRInterfaceError.unableToDecodeData)
                    return
            }
            
            currentObject = Object(coords: coords, organization: organization, type: type, name: name, code: code)
            callback(nil)
        }
    }
}
