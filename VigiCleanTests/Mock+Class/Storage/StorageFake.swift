//
//  StorageFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 13/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageFake: Storage {
    let data: Data?
    let error: Error?
    
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    override func reference(withPath string: String) -> StorageReference {
        return StorageReferenceFake(data: data, error: error)
    }
}
