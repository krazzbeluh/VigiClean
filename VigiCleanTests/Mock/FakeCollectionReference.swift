//
//  FakeCollectionReference.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 28/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FakeCollectionReference: CollectionReference {
    private let error: Error?
    
    init(error: Error?) {
        self.error = error
    }
    
    override func document(_ documentPath: String) -> DocumentReference {
        return FakeDocumentReference(error: error)
    }
}
