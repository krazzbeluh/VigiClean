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
    
    func convertToAuthError(_ error: Error) -> AuthErrorCode? {
        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            return nil
        }
        return errCode
    }
    
    func convertToStorageError(_ error: Error) -> StorageErrorCode? {
        guard let errCode = StorageErrorCode(rawValue: error._code) else {
            return .unknown
        }
        return errCode
    }
    
    func convertToFirestoreError(_ error: Error) -> FirestoreErrorCode? {
        guard let errCode = FirestoreErrorCode(rawValue: error._code) else {
            return .unknown
        }
        return errCode
    }
    
    func convertToFunctionsError(_ error: Error) -> FunctionsErrorCode? {
        guard let errCode = FunctionsErrorCode(rawValue: error._code) else {
            return .unknown
        }
        return errCode
    }
}

extension AuthErrorCode: Error {}
extension StorageErrorCode: Error {}
extension FunctionsErrorCode: Error {}
extension FirestoreErrorCode: Error {}
