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

class BasePresenter { // TODO: review error management with new errors conversio
    /*func convertAlert(with error: Error) -> String {
        let message: String
        
        message = convertVigiCleanError(error)
            ?? convertFirestoreError(error)
            ?? convertStorageError(error)
            ?? "Unknown error !"
        
        return message
    }*/
    
    private func convertVigiCleanError(_ error: Error) -> String? {
        if let error = error as? Scanner.ScannerError {
            return "\(error)"
        } else if let error = error as? ObjectManager.ObjectError {
            return "\(error)"
        } else if let error = error as? AccountManager.UAccountError {
            return "\(error)"
        } else if let error = error as? FirebaseInterface.FIRInterfaceError {
            return "\(error)"
        } else {
            return nil
        }
    }
}

// MARK: Auth
extension BasePresenter {
    func getAuthErrorCode(error: Error) -> String? {
        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            return nil
        }
        return convertAuthError(errCode)
    }
    
    private func convertAuthError(_ error: AuthErrorCode) -> String? { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        
        let message: String
        
        switch error {
        case .invalidCustomToken:
            message = "\(error)"
        case .customTokenMismatch:
            message = "\(error)"
        case .invalidCredential:
            message = "\(error)"
        case .userDisabled:
            message = "\(error)"
        case .operationNotAllowed:
            message = "\(error)"
        case .emailAlreadyInUse:
            message = "Cette adresse mail est déjà utilisée"
        case .invalidEmail:
            message = "\(error)"
        case .wrongPassword:
            message = "Mot de passe incorrect"
        case .tooManyRequests:
            message = "Opération impossible, veuillez réessayer ultérieurement"
        case .userNotFound:
            message = "userNotFound"
        case .accountExistsWithDifferentCredential:
            message = "\(error)"
        case .requiresRecentLogin:
            message = "\(error)"
        case .providerAlreadyLinked:
            message = "\(error)"
        case .noSuchProvider:
            message = "\(error)"
        case .invalidUserToken:
            message = "\(error)"
        case .networkError:
            message = "\(error)"
        case .userTokenExpired:
            message = "\(error)"
        case .invalidAPIKey:
            message = "\(error)"
        case .userMismatch:
            message = "\(error)"
        case .credentialAlreadyInUse:
            message = "\(error)"
        case .weakPassword:
            message = "\(error)"
        case .appNotAuthorized:
            message = "\(error)"
        case .expiredActionCode:
            message = "\(error)"
        case .invalidActionCode:
            message = "\(error)"
        case .invalidMessagePayload:
            message = "\(error)"
        case .invalidSender:
            message = "\(error)"
        case .invalidRecipientEmail:
            message = "\(error)"
        case .missingEmail:
            message = "\(error)"
        case .missingIosBundleID:
            message = "\(error)"
        case .missingAndroidPackageName:
            message = "\(error)"
        case .unauthorizedDomain:
            message = "\(error)"
        case .invalidContinueURI:
            message = "\(error)"
        case .missingContinueURI:
            message = "\(error)"
        case .missingPhoneNumber:
            message = "\(error)"
        case .invalidPhoneNumber:
            message = "\(error)"
        case .missingVerificationCode:
            message = "\(error)"
        case .invalidVerificationCode:
            message = "\(error)"
        case .missingVerificationID:
            message = "\(error)"
        case .invalidVerificationID:
            message = "\(error)"
        case .missingAppCredential:
            message = "\(error)"
        case .invalidAppCredential:
            message = "\(error)"
        case .sessionExpired:
            message = "\(error)"
        case .quotaExceeded:
            message = "\(error)"
        case .missingAppToken:
            message = "\(error)"
        case .notificationNotForwarded:
            message = "\(error)"
        case .appNotVerified:
            message = "\(error)"
        case .captchaCheckFailed:
            message = "\(error)"
        case .webContextAlreadyPresented:
            message = "\(error)"
        case .webContextCancelled:
            message = "\(error)"
        case .appVerificationUserInteractionFailure:
            message = "\(error)"
        case .invalidClientID:
            message = "\(error)"
        case .webNetworkRequestFailed:
            message = "\(error)"
        case .webInternalError:
            message = "\(error)"
        case .webSignInUserInteractionFailure:
            message = "\(error)"
        case .localPlayerNotAuthenticated:
            message = "\(error)"
        case .nullUser:
            message = "\(error)"
        case .dynamicLinkNotActivated:
            message = "\(error)"
        case .invalidProviderID:
            message = "\(error)"
        case .invalidDynamicLinkDomain:
            message = "\(error)"
        case .rejectedCredential:
            message = "\(error)"
        case .gameKitNotLinked:
            message = "\(error)"
        case .missingOrInvalidNonce:
            message = "\(error)"
        case .missingClientIdentifier:
            message = "\(error)"
        case .keychainError:
            message = "\(error)"
        case .internalError:
            message = "\(error)"
        case .malformedJWT:
            message = "\(error)"
        @unknown default:
            return nil
        }
        
        return message
    }
}

// MARK: Storage
extension BasePresenter {
    func getStorageErrorCode(error: Error) -> String? {
        guard let error = error as? StorageErrorCode else {
            return nil
        }
        
        return convertStorageError(error)
    }
    
    private func convertStorageError(_ error: StorageErrorCode) -> String? { // swiftlint:disable:this cyclomatic_complexity line_length
        let message: String
        
        switch error {
        case .unknown:
            message = "\(error)"
        case .objectNotFound:
            message = "\(error)"
        case .bucketNotFound:
            message = "\(error)"
        case .projectNotFound:
            message = "\(error)"
        case .quotaExceeded:
            message = "\(error)"
        case .unauthenticated:
            message = "\(error)"
        case .unauthorized:
            message = "\(error)"
        case .retryLimitExceeded:
            message = "\(error)"
        case .nonMatchingChecksum:
            message = "\(error)"
        case .downloadSizeExceeded:
            message = "\(error)"
        case .cancelled:
            message = "\(error)"
        case .invalidArgument:
            message = "\(error)"
        @unknown default:
            return nil
        }
        
        return message
    }
}

// MARK: Firestore
extension BasePresenter {
    func getFirestoreErrorCode(error: Error) -> String? {
        guard let error = error as? FirestoreErrorCode else {
            return nil
        }
        
        return convertFirestoreError(error)
    }
    
    private func convertFirestoreError(_ error: FirestoreErrorCode) -> String? { // swiftlint:disable:this cyclomatic_complexity line_length
        let message: String
        
        switch error {
        case .OK:
            message = "\(error)"
        case .cancelled:
            message = "\(error)"
        case .unknown:
            message = "\(error)"
        case .invalidArgument:
            message = "\(error)"
        case .deadlineExceeded:
            message = "\(error)"
        case .notFound:
            message = "\(error)"
        case .alreadyExists:
            message = "\(error)"
        case .permissionDenied:
            message = "\(error)"
        case .resourceExhausted:
            message = "\(error)"
        case .failedPrecondition:
            message = "\(error)"
        case .aborted:
            message = "\(error)"
        case .outOfRange:
            message = "\(error)"
        case .unimplemented:
            message = "\(error)"
        case .internal:
            message = "\(error)"
        case .unavailable:
            message = "\(error)"
        case .dataLoss:
            message = "\(error)"
        case .unauthenticated:
            message = "\(error)"
        @unknown default:
            return nil
        }
        
        return message
    }
}

// MARK: Functions
extension BasePresenter {
    func getFunctionsErrorCode(error: Error) -> String? {
        guard let error = error as? FunctionsErrorCode else {
            return nil
        }
        
        return convertFunctionsError(error)
    }
    
    func convertFunctionsError(_ error: FunctionsErrorCode) -> String? { // swiftlint:disable:this cyclomatic_complexity
        let message: String
        
        switch error {
        case .OK:
            message = "\(error)"
        case .cancelled:
            message = "\(error)"
        case .unknown:
            message = "\(error)"
        case .invalidArgument:
            message = "\(error)"
        case .deadlineExceeded:
            message = "\(error)"
        case .notFound:
            message = "\(error)"
        case .alreadyExists:
            message = "\(error)"
        case .permissionDenied:
            message = "\(error)"
        case .resourceExhausted:
            message = "\(error)"
        case .failedPrecondition:
            message = "\(error)"
        case .aborted:
            message = "\(error)"
        case .outOfRange:
            message = "\(error)"
        case .unimplemented:
            message = "\(error)"
        case .internal:
            message = "\(error)"
        case .unavailable:
            message = "\(error)"
        case .dataLoss:
            message = "\(error)"
        case .unauthenticated:
            message = "\(error)"
        @unknown default:
            return nil
        }
        
        return message
    }
}
