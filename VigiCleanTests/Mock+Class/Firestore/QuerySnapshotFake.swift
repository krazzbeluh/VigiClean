//
//  QuerySnapshotFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class QuerySnapshotFake: QuerySnapshot {
    let datas: [[String: Any]]?
    
    init(vigiclean: Int? = nil) {
        self.datas = FirestoreFake.datas
    }
    
    override var documents: [QueryDocumentSnapshot] {
        var documentsSnapshots = [QueryDocumentSnapshot]()
        
        if let datas = datas, datas.count > 0 {
            for data in datas {
                documentsSnapshots.append(QueryDocumentSnapshotFake(data: data))
            }
        }
        
        return documentsSnapshots
    }
}
