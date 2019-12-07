//
//  BasePresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

class BasePresenter {
    func convertAlert(with error: Error) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length line_length
        let message: String
        // TODO: review method. convertAuthError never throws
        // TODO: scannerError, FireStoreError, ObjectError, UAccountError, FIRInterfaceError, UIError
        if let error = try? convertAuthError(error) {
            switch error {
            case .invalidCustomToken:
                message = "Error: \(error)"
            case .customTokenMismatch:
                message = "Error: \(error)"
            case .invalidCredential:
                message = "Error: \(error)"
            case .userDisabled:
                message = "Error: \(error)"
            case .operationNotAllowed:
                message = "Error: \(error)"
            case .emailAlreadyInUse:
                message = "Error: \(error)"
            case .invalidEmail:
                message = "Error: \(error)"
            case .wrongPassword:
                message = "Error: \(error)"
            case .tooManyRequests:
                message = "Error: \(error)"
            case .userNotFound:
                message = "Error: \(error)"
            case .accountExistsWithDifferentCredential:
                message = "Error: \(error)"
            case .requiresRecentLogin:
                message = "Error: \(error)"
            case .providerAlreadyLinked:
                message = "Error: \(error)"
            case .noSuchProvider:
                message = "Error: \(error)"
            case .invalidUserToken:
                message = "Error: \(error)"
            case .networkError:
                message = "Error: \(error)"
            case .userTokenExpired:
                message = "Error: \(error)"
            case .invalidAPIKey:
                message = "Error: \(error)"
            case .userMismatch:
                message = "Error: \(error)"
            case .credentialAlreadyInUse:
                message = "Error: \(error)"
            case .weakPassword:
                message = "Error: \(error)"
            case .appNotAuthorized:
                message = "Error: \(error)"
            case .expiredActionCode:
                message = "Error: \(error)"
            case .invalidActionCode:
                message = "Error: \(error)"
            case .invalidMessagePayload:
                message = "Error: \(error)"
            case .invalidSender:
                message = "Error: \(error)"
            case .invalidRecipientEmail:
                message = "Error: \(error)"
            case .missingEmail:
                message = "Error: \(error)"
            case .missingIosBundleID:
                message = "Error: \(error)"
            case .missingAndroidPackageName:
                message = "Error: \(error)"
            case .unauthorizedDomain:
                message = "Error: \(error)"
            case .invalidContinueURI:
                message = "Error: \(error)"
            case .missingContinueURI:
                message = "Error: \(error)"
            case .missingPhoneNumber:
                message = "Error: \(error)"
            case .invalidPhoneNumber:
                message = "Error: \(error)"
            case .missingVerificationCode:
                message = "Error: \(error)"
            case .invalidVerificationCode:
                message = "Error: \(error)"
            case .missingVerificationID:
                message = "Error: \(error)"
            case .invalidVerificationID:
                message = "Error: \(error)"
            case .missingAppCredential:
                message = "Error: \(error)"
            case .invalidAppCredential:
                message = "Error: \(error)"
            case .sessionExpired:
                message = "Error: \(error)"
            case .quotaExceeded:
                message = "Error: \(error)"
            case .missingAppToken:
                message = "Error: \(error)"
            case .notificationNotForwarded:
                message = "Error: \(error)"
            case .appNotVerified:
                message = "Error: \(error)"
            case .captchaCheckFailed:
                message = "Error: \(error)"
            case .webContextAlreadyPresented:
                message = "Error: \(error)"
            case .webContextCancelled:
                message = "Error: \(error)"
            case .appVerificationUserInteractionFailure:
                message = "Error: \(error)"
            case .invalidClientID:
                message = "Error: \(error)"
            case .webNetworkRequestFailed:
                message = "Error: \(error)"
            case .webInternalError:
                message = "Error: \(error)"
            case .webSignInUserInteractionFailure:
                message = "Error: \(error)"
            case .localPlayerNotAuthenticated:
                message = "Error: \(error)"
            case .nullUser:
                message = "Error: \(error)"
            case .dynamicLinkNotActivated:
                message = "Error: \(error)"
            case .invalidProviderID:
                message = "Error: \(error)"
            case .invalidDynamicLinkDomain:
                message = "Error: \(error)"
            case .rejectedCredential:
                message = "Error: \(error)"
            case .gameKitNotLinked:
                message = "Error: \(error)"
            case .missingOrInvalidNonce:
                message = "Error: \(error)"
            case .missingClientIdentifier:
                message = "Error: \(error)"
            case .keychainError:
                message = "Error: \(error)"
            case .internalError:
                message = "Error: \(error)"
            case .malformedJWT:
                message = "Error: \(error)"
            @unknown default:
                message = "Error: Unknown error: \(error)"
            }
        } else {
            message = ""
        }
        return message
    }
    
    private func convertAuthError(_ error: Error) throws -> AuthErrorCode {
        guard let errCode = AuthErrorCode(rawValue: error._code) else {
            throw FIRInterfaceError.unableToDecodeError
        }
        
        return errCode
    }
}
