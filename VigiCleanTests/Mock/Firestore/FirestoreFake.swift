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
    let documentSnapshot: DocumentSnapshot?
    
    init(error: Error?, documentSnapshot: DocumentSnapshot?) {
        self.error = error
        self.documentSnapshot = documentSnapshot
    }
}
