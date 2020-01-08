//
//  ObjectManager.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFunctions

class ObjectManager {
    enum ObjectError: Error {
        case unableToDecodeData, userNotLoggedIn, nilInTextField, noActionsInObject, actionNotFound
    }
    
    private var database = Firestore.firestore()
    private lazy var functions = Functions.functions()
    
    init() {
        database = Firestore.firestore()
        functions = Functions.functions()
    }
    
    init(database: Firestore, functions: Functions) {
        self.database = database
        self.functions = functions
    }
    
    func getObject(code: String, callback: @escaping (Result<Object, Error>) -> Void) {
        let docRef = database.collection("Object").document(code)
        docRef.getDocument { (document, error) in
            guard let document = document, document.exists else {
                let errCode: FirestoreErrorCode! = ErrorHandler().convertToFirestoreError(error!)
                
                callback(.failure(errCode))
                return
            }
            
            guard let data = document.data(),
                let coords = data["coords"] as? GeoPoint,
                let organization = data["organization"] as? String,
                let type = data["type"] as? String,
                let name = data["name"] as? String else {
                    callback(.failure(FirebaseInterface.FIRInterfaceError.unableToDecodeData))
                    return
            }
            
            let object = Object(coords: coords,
                                organization: organization,
                                type: type,
                                name: name,
                                code: code)
            
            Object.currentObject = object
            callback(.success(object))
        }
    }
    
    func getActions(for object: Object, callback: @escaping (Result<Void, Error>) -> Void) {
        self.getActions(for: object.type) { (result) in
            switch result {
            case .success(let actions):
                object.actions = actions
                callback(.success(Void()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    func getEmployeeActions(for object: Object, callback: @escaping (Result<Void, Error>) -> Void) {
        self.getEmployeeActions(for: object.type) { (result) in
            switch result {
            case .success(let actions):
                object.employeeActions = actions
                callback(.success(Void()))
            case .failure(let error):
                callback(.failure(error))
            }
        }
    }
    
    private func getActions(for type: String, callback: @escaping (Result<[Action], Error>) -> Void) {
        let docRef = database.collection("actions").document(type)
        docRef.getDocument { document, error in
            if let error = error {
                let errCode = ErrorHandler().convertToFirestoreError(error)
                callback(.failure(errCode!))
                return
            }
            
            guard let document = document, document.exists,
                let data = document.data() as? [String: String] else {
                    callback(.failure(FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                    return
            }
            
            var actions = [Action]()
            
            for (strIndex, action) in data {
                if let index = Int(strIndex) {
                    actions.append(Action(index: index, message: action))
                }
            }
            
            callback(.success(actions))
        }
    }
    
    private func getEmployeeActions(for type: String, callback: @escaping (Result<[Action], Error>) -> Void) {
        let docRef = database.collection("performedActions").document(type)
        docRef.getDocument { document, error in
            if let error = error {
                let errCode = ErrorHandler().convertToFirestoreError(error)
                callback(.failure(errCode!))
                return
            }
            
            guard let document = document, document.exists,
                let data = document.data() as? [String: String]else {
                    callback(.failure(FirebaseInterface.FIRInterfaceError.documentDoesNotExists))
                    return
            }
            
            var actions = [Action]()
            
            for (strIndex, action) in data {
                if let index = Int(strIndex) {
                    actions.append(Action(index: index, message: action))
                }
            }
            
            callback(.success(actions))
        }
    }
    
    func sendRequest(for object: Object, with action: Action, callback: @escaping (Error?) -> Void) {
        guard let uid = AccountManager.currentUser.user?.uid else {
            callback(ObjectError.userNotLoggedIn)
            return
        }
        
        database.collection("Request").addDocument(data: [
            "code": object.code,
            "action": action.index,
            "date": Date(),
            "user": uid,
            "isValidOperation": NSNull()
        ]) { error in
            guard let error = error else {
                callback(nil)
                return
            }
            let errCode = ErrorHandler().convertToFirestoreError(error)
            callback(errCode!)
        }
    }
    
    func resolvedRequest(for object: Object, with action: Action, isValid: Bool, callback: @escaping(Error?) -> Void) {
        functions.httpsCallable("resolvedRequest?code=\(object.code)&action=\(action.index)")
            .call { (_, error) in
                guard let error = error else {
                    callback(nil)
                    return
                }
                
                let errCode = ErrorHandler().convertToFunctionsError(error)
                callback(errCode)
        }
    }
}
