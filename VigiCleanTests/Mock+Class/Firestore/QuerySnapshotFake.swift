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
    var datas: [[String: Any]]
    
    init(datas: [[String: Any]]) {
        self.datas = datas
    }
    
    private func getNextData() -> [String: Any] {
        guard let data = self.datas.first else {
            return [String: Any]()
        }
        self.datas.removeFirst()
        return data
    }
    
    override var documents: [QueryDocumentSnapshot] {
        var documentsSnapshots = [QueryDocumentSnapshot]()
        
        for data in self.datas {
            documentsSnapshots.append(QueryDocumentSnapshotFake(data: data))
        }
        
        return documentsSnapshots
    }
}
