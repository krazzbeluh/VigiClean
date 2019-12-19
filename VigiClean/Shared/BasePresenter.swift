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

class BasePresenter { // TODO: review error management with new errors conversio
    func convertAlert(with error: Error) -> String {
        let message: String
        
        message = convertVigiCleanError(error)
            ?? convertFirestoreError(error)
            ?? convertAuthError(error)
            ?? convertStorageError(error)
            ?? "Unknown error !"
        
        return message
    }
    
    private func convertFirestoreError(_ error: Error) -> String? { // swiftlint:disable:this cyclomatic_complexity line_length function_body_length
        guard let errCode = FirestoreErrorCode(rawValue: error._code) else {
            return nil
        }
        
        let message: String
        
        switch errCode {
        case .OK:
            message = "\(errCode)"
        case .cancelled:
            message = "\(errCode)"
        case .unknown:
            message = "\(errCode)"
        case .invalidArgument:
            message = "\(errCode)"
        case .deadlineExceeded:
            message = "\(errCode)"
        case .notFound:
            message = "\(errCode)"
        case .alreadyExists:
            message = "\(errCode)"
        case .permissionDenied:
            message = "\(errCode)"
        case .resourceExhausted:
            message = "\(errCode)"
        case .failedPrecondition:
            message = "\(errCode)"
        case .aborted:
            message = "\(errCode)"
        case .outOfRange:
            message = "\(errCode)"
        case .unimplemented:
            message = "\(errCode)"
        case .internal:
            message = "\(errCode)"
        case .unavailable:
            message = "\(errCode)"
        case .dataLoss:
            message = "\(errCode)"
        case .unauthenticated:
            message = "\(errCode)"
        @unknown default:
            return nil
        }
        
        return message
    }
    
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
    
    private func convertStorageError(_ error: Error) -> String? {
        guard let error = error as? StorageErrorCode else {
            return nil
        }
        
        return "wait a minute lol \(error)" // TODO
    }
}

extension BasePresenter {
    private func convertAuthError(_ error: Error) -> String? { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length

        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            return nil
        }
        
        let message: String
        
        switch errCode {
        case .invalidCustomToken:
            message = "\(errCode)"
        case .customTokenMismatch:
            message = "\(errCode)"
        case .invalidCredential:
            message = "\(errCode)"
        case .userDisabled:
            message = "\(errCode)"
        case .operationNotAllowed:
            message = "\(errCode)"
        case .emailAlreadyInUse:
            message = "Cette adresse mail est déjà utilisée"
        case .invalidEmail:
            message = "\(errCode)"
        case .wrongPassword:
            message = "\(errCode)"
        case .tooManyRequests:
            message = "\(errCode)"
        case .userNotFound:
            message = "userNotFound"
        case .accountExistsWithDifferentCredential:
            message = "\(errCode)"
        case .requiresRecentLogin:
            message = "\(errCode)"
        case .providerAlreadyLinked:
            message = "\(errCode)"
        case .noSuchProvider:
            message = "\(errCode)"
        case .invalidUserToken:
            message = "\(errCode)"
        case .networkError:
            message = "\(errCode)"
        case .userTokenExpired:
            message = "\(errCode)"
        case .invalidAPIKey:
            message = "\(errCode)"
        case .userMismatch:
            message = "\(errCode)"
        case .credentialAlreadyInUse:
            message = "\(errCode)"
        case .weakPassword:
            message = "\(errCode)"
        case .appNotAuthorized:
            message = "\(errCode)"
        case .expiredActionCode:
            message = "\(errCode)"
        case .invalidActionCode:
            message = "\(errCode)"
        case .invalidMessagePayload:
            message = "\(errCode)"
        case .invalidSender:
            message = "\(errCode)"
        case .invalidRecipientEmail:
            message = "\(errCode)"
        case .missingEmail:
            message = "\(errCode)"
        case .missingIosBundleID:
            message = "\(errCode)"
        case .missingAndroidPackageName:
            message = "\(errCode)"
        case .unauthorizedDomain:
            message = "\(errCode)"
        case .invalidContinueURI:
            message = "\(errCode)"
        case .missingContinueURI:
            message = "\(errCode)"
        case .missingPhoneNumber:
            message = "\(errCode)"
        case .invalidPhoneNumber:
            message = "\(errCode)"
        case .missingVerificationCode:
            message = "\(errCode)"
        case .invalidVerificationCode:
            message = "\(errCode)"
        case .missingVerificationID:
            message = "\(errCode)"
        case .invalidVerificationID:
            message = "\(errCode)"
        case .missingAppCredential:
            message = "\(errCode)"
        case .invalidAppCredential:
            message = "\(errCode)"
        case .sessionExpired:
            message = "\(errCode)"
        case .quotaExceeded:
            message = "\(errCode)"
        case .missingAppToken:
            message = "\(errCode)"
        case .notificationNotForwarded:
            message = "\(errCode)"
        case .appNotVerified:
            message = "\(errCode)"
        case .captchaCheckFailed:
            message = "\(errCode)"
        case .webContextAlreadyPresented:
            message = "\(errCode)"
        case .webContextCancelled:
            message = "\(errCode)"
        case .appVerificationUserInteractionFailure:
            message = "\(errCode)"
        case .invalidClientID:
            message = "\(errCode)"
        case .webNetworkRequestFailed:
            message = "\(errCode)"
        case .webInternalError:
            message = "\(errCode)"
        case .webSignInUserInteractionFailure:
            message = "\(errCode)"
        case .localPlayerNotAuthenticated:
            message = "\(errCode)"
        case .nullUser:
            message = "\(errCode)"
        case .dynamicLinkNotActivated:
            message = "\(errCode)"
        case .invalidProviderID:
            message = "\(errCode)"
        case .invalidDynamicLinkDomain:
            message = "\(errCode)"
        case .rejectedCredential:
            message = "\(errCode)"
        case .gameKitNotLinked:
            message = "\(errCode)"
        case .missingOrInvalidNonce:
            message = "\(errCode)"
        case .missingClientIdentifier:
            message = "\(errCode)"
        case .keychainError:
            message = "\(errCode)"
        case .internalError:
            message = "\(errCode)"
        case .malformedJWT:
            message = "\(errCode)"
        @unknown default:
            return nil
        }
        
        return message
    }
}
