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
    var datas: [[String: Any]]?
    let error: Error?
    
    init(datas: [[String: Any]]?, error: Error?) {
        self.datas = datas
        self.error = error
    }
    
    override func getDocuments(completion: @escaping FIRQuerySnapshotBlock) {
        if let datas = datas {
            completion(QuerySnapshotFake(datas: datas), error)
        } else {
            completion(nil, error)
        }
    }
}
