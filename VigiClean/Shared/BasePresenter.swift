//
//  BasePresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseFunctions

class BasePresenter {
    
    func convertError(_ error: Error) -> String { // swiftlint:disable:this cyclomatic_complexity
        let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
        
        switch error {
        case let error as FirebaseInterface.FIRInterfaceError:
            switch error {
            default:
                return defaultMessage
            }
        case let error as StorageErrorCode:
            switch error {
            default:
                return defaultMessage
            }
        case let error as FunctionsErrorCode:
            switch error {
            default:
                return defaultMessage
            }
        case let error as AuthErrorCode:
            switch error {
            default:
                return defaultMessage
            }
        case let error as FirestoreErrorCode:
            switch error {
            default:
                return defaultMessage
            }
        default:
            return defaultMessage
        }
    }
}
