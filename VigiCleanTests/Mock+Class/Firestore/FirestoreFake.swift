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
    let errors: [Error?]?
    let data: [String: Any]?
    
    init(errors: [Error?]?, data: [String: Any]?) {
        self.errors = errors
        self.data = data
    }
    
    override func collection(_ collectionPath: String) -> CollectionReference {
        return CollectionReferenceFake(errors: errors, data: data)
    }
}
