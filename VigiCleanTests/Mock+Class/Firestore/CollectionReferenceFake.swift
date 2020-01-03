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
    let error: Error?
    let data: [String: Any]?
    
    init(error: Error?, data: [String: Any]?) {
        self.error = error
        self.data = data
    }
    
    override func document(_ documentPath: String) -> DocumentReference {
        return DocumentReferenceFake(error: error, data: data)
    }
}
