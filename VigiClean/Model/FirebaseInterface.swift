//
//  FirebaseInterface.swift
//  VigiClean
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFunctions
import FirebaseStorage

class FirebaseInterface {
    enum FIRInterfaceError: Error {
        case documentDoesNotExists, unableToDecodeData, unableToDecodeError
    }
    
    static func convertStorageError(error: Error) -> StorageErrorCode {
        guard let errCode = StorageErrorCode(rawValue: error._code) else {
            return StorageErrorCode.objectNotFound
        }
        
        return errCode
    }
}

extension FunctionsErrorCode: Error { // TODO: give error type to every firebase error code
    
}

extension StorageErrorCode: Error {
    
}
