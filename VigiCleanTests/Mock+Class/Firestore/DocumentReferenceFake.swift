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
    var errors: [Error?]?
    let data: [String: Any]?
    
    init(errors: [Error?]?, data: [String: Any]?) {
        self.errors = errors
        self.data = data
    }
    
    override func setData(_ documentData: [String: Any], completion: ((Error?) -> Void)? = nil) {
        completion!(getNextError())
    }
    
    override func getDocument(completion: @escaping FIRDocumentSnapshotBlock) {
        let error = getNextError()
        completion(DocumentSnapshotFake(error: error, data: data), error)
    }
    
    override func updateData(_ fields: [AnyHashable: Any], completion: ((Error?) -> Void)? = nil) {
        guard let completion = completion else {
            return
        }
        
        completion(getNextError())
    }
    
    override func addSnapshotListener(_ listener: @escaping FIRDocumentSnapshotBlock) -> ListenerRegistration {
        if let error = getNextError() {
            listener(nil, error)
        } else {
            listener(DocumentSnapshotFake(error: getNextError(), data: data), getNextError())
        }
        
        return ListenerRegistrationFake()
    }
    
    private func getNextError() -> Error? {
        guard let error = errors?.first else {
            return nil
        }
        
        errors?.removeFirst()
        
        return error
    }
}
