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
        if FirestoreFake.datas != nil, FirestoreFake.datas!.count > 0 {
            let querySnapshot = QuerySnapshotFake()
            FirestoreFake.datas!.removeFirst()
            completion(querySnapshot, FirestoreFake.getNextError())
        } else {
            completion(nil, FirestoreFake.getNextError())
        }
    }
    
    override func whereField(_ field: String, isEqualTo value: Any) -> Query {
        return QueryFake()
    }
}
