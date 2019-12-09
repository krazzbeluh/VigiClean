//
//  ObjectManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FIRInterfaceError: Error { // TODO
    case documentDoesNotExists, unableToDecodeData, unableToDecodeError
}

class ObjectManager {
    enum ObjectError: Error {
        case unableToDecodeData, userNotLoggedIn, nilInTextField
    }
    
    let database = Firestore.firestore()
    let accountManager = AccountManager()
    
    func getObject(code: String, callback: @escaping (Error?) -> Void) {
        let docRef = database.collection("Object").document(code)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                callback(error ?? FIRInterfaceError.documentDoesNotExists)
                return
            }
            
            guard let data = document.data(),
                let coords = data["coords"] as? GeoPoint,
                let organization = data["organization"] as? String,
                let type = data["type"] as? String,
                let name = data["name"] as? String else {
                    callback(FIRInterfaceError.unableToDecodeData)
                    return
            }
            
            self.getActions(for: type) { result in
                switch result {
                case .success(let actions):
                    Object.currentObject = Object(coords: coords,
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
    
    private func getActions(for type: String, callback: @escaping (Result<[String], Error>) -> Void) {
        let docRef = database.collection("actions").document(type)
        docRef.getDocument { document, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                callback(.failure(FIRInterfaceError.documentDoesNotExists))
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
    
    func sendRequest(for object: Object, with action: String, callback: @escaping (Error?) -> Void) {
        guard let uid = accountManager.currentUser?.uid else {
            callback(ObjectError.userNotLoggedIn)
            return
        }
        
        database.collection("Request").addDocument(data: [
            "code": object.code,
            "action": action,
            "date": Date(),
            "user": uid,
            "isValidOperation": NSNull()
        ]) { error in
            callback(error)
        }
    }
}
