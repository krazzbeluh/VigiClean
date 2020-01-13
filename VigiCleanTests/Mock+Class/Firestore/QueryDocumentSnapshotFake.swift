//
//  QueryDocumentSnapshotFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class QueryDocumentSnapshotFake: QueryDocumentSnapshot {
    let dataDictionary: [String: Any]
    
    init(data: [String: Any]) {
        self.dataDictionary = data
    }
    
    override func data() -> [String: Any] {
        return dataDictionary
    }
    
    override var documentID: String {
        return ""
    }
}
