//
//  ObjectManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

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
                callback(error ?? FirebaseInterface.FIRInterfaceError.documentDoesNotExists)
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
            
            self.getActions(for: type) { result in
                switch result {
                case .success(let userActions):
                    self.getEmployeeActions(for: type) { result in
                        switch result {
                        case .success(let employeeActions):
                            Object.currentObject = Object(coords: coords,
                            organization: organization,
                            type: type,
                            name: name,
                            code: code,
                            userActions: userActions,
                            employeeActions: employeeActions)

                            callback(nil)
                        case .failure(let error):
                            callback(error)
                        }
                    }
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
                callback(.failure(FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
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
    
    private func getEmployeeActions(for type: String, callback: @escaping (Result<[String], Error>) -> Void) {
        let docRef = database.collection("performedActions").document(type)
        docRef.getDocument { document, error in
            if let error = error {
                callback(.failure(error))
                return
            }
            
            guard let document = document, document.exists else {
                callback(.failure(FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                return
            }
            
            guard let data = document.data() as? [String: String] else {
                callback(.failure(ObjectError.unableToDecodeData))
                return
            }
            
            var actions = [String]()
            
            for (_, action) in data {
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
