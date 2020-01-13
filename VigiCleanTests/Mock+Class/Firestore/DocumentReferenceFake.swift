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
    init(vigiclean: Int?  = nil) {}
    
    override func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
        completion!(FirestoreFake.getNextError())
    }
    
    override func getDocument(completion: @escaping FIRDocumentSnapshotBlock) {
        let error = FirestoreFake.getNextError()
        completion(DocumentSnapshotFake(error: error, data: FirestoreFake.getNextData()), error)
    }
    
    override func updateData(_ fields: [AnyHashable: Any], completion: ((Error?) -> Void)? = nil) {
        guard let completion = completion else {
            return
        }
        
        completion(FirestoreFake.getNextError())
    }
    
    override func addSnapshotListener(_ listener: @escaping FIRDocumentSnapshotBlock) -> ListenerRegistration {
        if let error = FirestoreFake.getNextError() {
            listener(nil, error)
        } else {
            listener(DocumentSnapshotFake(error: FirestoreFake.getNextError(),
                                          data: FirestoreFake.getNextData()),
                     FirestoreFake.getNextError())
        }
        
        return ListenerRegistrationFake()
    }
}
