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
        switch error {
        case let error as FirebaseInterface.FIRInterfaceError:
            let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
            switch error {
            default:
                return defaultMessage
            }
        case let error as StorageErrorCode:
            let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
            switch error {
            default:
                return defaultMessage
            }
        case let error as FunctionsErrorCode:
            let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
            switch error {
            default:
                return defaultMessage
            }
        case let error as AuthErrorCode:
            let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
            switch error {
            default:
                return defaultMessage
            }
        case let error as FirestoreErrorCode:
            let defaultMessage = "Opération impossible : Veuillez réessayer ultérieurement"
            switch error {
            default:
                return defaultMessage
            }
        default:
            fatalError(error.localizedDescription)
        }
    }
}
