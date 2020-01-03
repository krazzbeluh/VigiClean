//
//  DocumentReferenceFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 23/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class DocumentReferenceFake: DocumentReference {
    let error: Error?
    let data: [String: Any]?
    
    init(error: Error?, data: [String: Any]?) {
        self.error = error
        self.data = data
    }
    
    override func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
        completion!(error)
    }
    
    override func getDocument(completion: @escaping FIRDocumentSnapshotBlock) {
        completion(DocumentSnapshotFake(error: error, data: data), error)
    }
}
