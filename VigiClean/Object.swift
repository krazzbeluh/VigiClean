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
    enum ObjectError: Error {
        case documentDoesNotExists, unableToDecodeData
    }
    
    // MARK: Properties
    let coords: GeoPoint
    let organization: String
    let type: String
    let name: String
    
    let actions: [String]
    
    private init(coords: GeoPoint, organization: String, type: String, name: String, code: String, actions: [String]) {
        self.coords = coords
        self.organization = organization
        self.type = type
        self.name = name
        self.actions = actions
    }
    
    private static func getActions(for type: String, callback: @escaping (Result<[String], Error>) -> Void) {
        let docRef = FirebaseInterface.database.collection("actions").document(type)
        docRef.getDocument { document, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                callback(.failure(ObjectError.documentDoesNotExists))
                return
            }
            
            guard let data = document.data() as? [String: String] else {
                callback(.failure(ObjectError.unableToDecodeData))
                return
            }
            
            var actions = [String]()
            
            for (action, _) in data {
                actions.append(action)
            }

            callback(.success(actions))
        }
    }
    
    static var currentObject: Object?
    
    static func getObject(code: String, callback: @escaping (Error?) -> Void) {
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
            
            getActions(for: type) { result in
                switch result {
                case .success(let actions):
                    currentObject = Object(coords: coords,
                                           organization: organization,
                                           type: type,
                                           name: name,
                                           code: code,
                                           actions: actions)
                    callback(nil)
                case .failure(let error):
                    callback(error)
                }
            }
        }
    }
}
