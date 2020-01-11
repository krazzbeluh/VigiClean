//
//  ErrorHandler.swift
//  VigiClean
//
//  Created by Paul Leclerc on 21/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseFunctions

class ErrorHandler {
    
    enum Errors: Error {
        case canNotConvertError
    }
    
    func convertToAuthError(_ error: Error) -> AuthErrorCode! {
        return AuthErrorCode(rawValue: error._code)
    }
    
    func convertToStorageError(_ error: Error) -> StorageErrorCode! {
        return StorageErrorCode(rawValue: error._code)
    }
    
    func convertToFirestoreError(_ error: Error) -> FirestoreErrorCode! {
        return FirestoreErrorCode(rawValue: error._code)
    }
    
    func convertToFunctionsError(_ error: Error) -> FunctionsErrorCode! {
        return FunctionsErrorCode(rawValue: error._code)
    }
}

extension AuthErrorCode: Error {}
extension StorageErrorCode: Error {}
extension FunctionsErrorCode: Error {}
extension FirestoreErrorCode: Error {}
