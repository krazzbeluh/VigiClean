//
//  DocumentSnapshotFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 03/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DocumentSnapshotFake: DocumentSnapshot {
    let error: Error?
    let documentData: [String: Any]?
    
    init(error: Error?, data: [String: Any]?) {
        self.error = error
        self.documentData = data
    }
    
    override var exists: Bool {
        return documentData != nil
    }
    
    override func data() -> [String: Any]? {
        return documentData
    }
}
