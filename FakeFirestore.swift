//
//  FakeFirestore.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 28/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FakeFirestore: Firestore {
    let error: Error
    
    init(error: Error) {
        self.error = error
    }
    
    override func collection(_ collectionPath: String) -> CollectionReference {
        return FakeCollectionReference(michel: true)
    }
}
