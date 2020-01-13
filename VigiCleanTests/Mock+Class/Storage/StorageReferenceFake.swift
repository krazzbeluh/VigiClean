//
//  StorageReferenceFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageReferenceFake: StorageReference {
    let data: Data?
    let error: Error?
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    
    override func getData(maxSize size: Int64, completion: @escaping (Data?, Error?) -> Void) -> StorageDownloadTask {
        completion(data, error)
        
        return StorageDownloadTaskFake()
    }
}
