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
    
    init(error: Error?) {
        self.error = error
    }
    
    override func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
        completion!(error)
    }
}
