//
//  FirestoreFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FirestoreFake: Firestore {
    static var errors: [Error?]?
    static var datas: [[String: Any]]?
    
    init(errors: [Error?]?, datas: [[String: Any]]? = nil) {
        FirestoreFake.errors = errors
        FirestoreFake.datas = datas
    }
    
    static func getNextError() -> Error? {
        guard let error = FirestoreFake.errors?.first else {
            return nil
        }
        
        FirestoreFake.errors?.removeFirst()
        
        return error
    }
    
    static func getNextData() -> [String: Any]? {
        guard let data = FirestoreFake.datas?.first else {
            return nil
        }
        
        FirestoreFake.datas?.removeFirst()
        
        return data
    }
    
    override func collection(_ collectionPath: String) -> CollectionReference {
        return CollectionReferenceFake()
    }
}
