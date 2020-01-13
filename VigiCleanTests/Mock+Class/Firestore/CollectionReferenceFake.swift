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
    init(vigiclean: Int? = nil) {}
    
    override func document(_ documentPath: String) -> DocumentReference {
        return DocumentReferenceFake()
    }
    
    override func addDocument(data: [String: Any], completion: ((Error?) -> Void)? = nil) -> DocumentReference {
        if let completion = completion {
            completion(FirestoreFake.getNextError())
        }
        
        return DocumentReferenceFake()
    }
    
    override func order(by field: String) -> Query {
        return QueryFake()
    }
    
    override func whereField(_ field: String, isEqualTo value: Any) -> Query {
        return QueryFake()
    }
    
    override func whereField(_ field: String, in values: [Any]) -> Query {
        return QueryFake()
    }
}
