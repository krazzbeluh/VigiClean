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
    
    init(error: Error?) {
        self.error = error
    }
    
    override func collection(_ collectionPath: String) -> CollectionReference {
        return CollectionReferenceFake(error: error)
    }
}
