//
//  QueryFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class QueryFake: Query {
    init(vigiclean: Int? = nil) {}
    
    override func getDocuments(completion: @escaping FIRQuerySnapshotBlock) {
        if let data = FirestoreFake.getNextData() {
            completion(QuerySnapshotFake(datas: [data]), FirestoreFake.getNextError())
        } else {
            completion(nil, FirestoreFake.getNextError())
        }
    }
    
    override func whereField(_ field: String, isEqualTo value: Any) -> Query {
        return QueryFake()
    }
}
