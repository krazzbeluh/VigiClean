//
//  StorageFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 18/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseStorage

class StorageFake: Storage {
    let error: Error?
    
    init(error: Error?) {
        self.error = error
    }
}
