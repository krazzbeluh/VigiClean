//
//  CollectionReferenceFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 23/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class CollectionReferenceFake: CollectionReference {
    var errors: [Error?]?
    let data: [String: Any]?
    
    init(errors: [Error?]?, data: [String: Any]?) {
        self.errors = errors
        self.data = data
    }
    
    override func document(_ documentPath: String) -> DocumentReference {
        return DocumentReferenceFake(errors: errors, data: data)
    }
    
    override func addDocument(data: [String: Any], completion: ((Error?) -> Void)? = nil) -> DocumentReference {
        if let completion = completion {
            completion(getNextError())
        }
        
        return DocumentReferenceFake(errors: errors, data: data)
    }
    
    private func getNextError() -> Error? {
        guard let error = errors?.first else {
            return nil
        }
        
        errors?.removeFirst()
        
        return error
    }
}
