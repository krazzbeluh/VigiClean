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
    let error: Error?
    let data: [String: Any]?
    
    init(error: Error?, data: [String: Any]?) {
        self.error = error
        self.data = data
    }
    
    override func collection(_ collectionPath: String) -> CollectionReference {
        return CollectionReferenceFake(error: error, data: data)
    }
}
