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
    
    func convertError(_ error: Error) -> String { // swiftlint:disable:this cyclomatic_complexity function_body_length
        let defaultMessage = "Une erreur est survenue, veuillez réessayer ultérieurement."
        
        let message: String
        switch error {
        case let error as FirebaseInterfaceError:
            switch error {
            case .documentDoesNotExists:
                message = "Ressource introuvable. Veuillez réessayer ultérieurement."
            default:
                message = defaultMessage
            }
        case let error as StorageErrorCode:
            switch error {
            case .objectNotFound:
                message = "Ressource introuvable. Veuillez réessayer ultérieurement."
            case .unauthenticated:
                message = "Vous devez vous connecter pour accéder à cette ressource."
            case .unauthorized:
                message = "Vous n'êtes pas autorisé à accéder à cette ressource."
            case .downloadSizeExceeded:
                message = "Téléchargement impossible : fichier trop volumineux."
            case .cancelled:
                message = "Téléchargement annulé par le terminal."
            default:
                message = defaultMessage
            }
        case let error as FunctionsErrorCode:
            switch error {
            case .cancelled:
                message = "Téléchargement annulé par le terminal."
            case .notFound:
                message = "Certaines ressources étaient introuvables."
            case .alreadyExists:
                message = "Certaines ressources existent déjà."
            case .permissionDenied:
                message = "Vous n'êtes pas autorisé à accéder à cette ressource."
            case .dataLoss:
                message = "Certaines ressources demandées sont corrompues."
            case .unauthenticated:
                message = "Une erreur est survenue, essayez de vous reconnecter."
            default:
                message = defaultMessage
            }
        case let error as AuthErrorCode:
            switch error {
            case .invalidCredential:
                message = "Une erreur est survenue, veuillez essayer de vous reconnecter."
            case .userDisabled:
                message = "Votre compte est désactivé."
            case .emailAlreadyInUse:
                message = "Cette adresse email est déjà utilisée sur nos serveurs."
            case .invalidEmail:
                message = "Cette adresse email est inconnue."
            case .wrongPassword:
                message = "Mot de passe incorrect."
            case .userNotFound:
                message = "Ce compte est introuvable."
            case .requiresRecentLogin:
                message = "Une erreur est survenue ; Essayez de vous reconnecter."
            case .networkError:
                message = "Une erreur est survenue ; Vérifiez votre connexion puis réessayez."
            case .userTokenExpired:
                message = "Une erreur est survenue, veuillez essayer de vous reconnecter."
            case .userMismatch:
                message = "Une erreur est survenue, veuillez essayer de vous reconnecter."
            case .weakPassword:
                message = "Votre mot de passe est trop faible : Il doit contenir au moins 6 caractères."
            case .invalidRecipientEmail:
                message = "Cette adresse email est invalide."
            case .missingEmail:
                message = "Adresse email manquante."
            case .nullUser:
                message = "Une erreur est survenue ; Essayez de vous reconnecter."
            default:
                message = defaultMessage
            }
        case let error as FirestoreErrorCode:
            switch error {
            case .notFound:
                message = "Certaines ressources étaient introuvables."
            case .permissionDenied:
                message = "Vous n'êtes pas autorisé à accéder à cette ressource."
            case .dataLoss:
                message = "Cette ressource est probablement corrompue."
            case .unauthenticated:
                message = "Une erreur est survenue, essayez de vous reconnecter."
            default:
                message = defaultMessage
            }
        case let error as ObjectManager.ObjectError:
            switch error {
            case .userNotLoggedIn:
                message = "Une erreur est survenue, essayez de vous reconnecter."
            case .notEmployedUser:
                message = "Vous n'êtes pas autorisé à accéder à cette ressource"
            default:
                message = defaultMessage
            }
        case let error as UserError:
            switch error {
            case .nilInTextField:
                message = "Vous devez remplir tous les champs."
            }
        case let error as ScannerError:
            switch error {
            case .scanNotSupported:
                message = "Votre appareil ne semble pas supporter le scan."
            case .invalidQRCode:
                message = "Ce code QR n'est pas un code VigiClean."
            }
        case let error as AccountManager.UAccountError:
            switch error {
            case .notMatchingPassword:
                message = "Les mots de passe ne correspondent pas."
            case .userNotLoggedIn:
                message = "Opération impossible, essayez de vous reconnecter."
            case .userNotLoggedInWithEmail:
                message = "Opétation impossible, inscrivez-vous."
            case .notEnoughCredits:
                message = "Solde insuffisant."
            default:
                message = defaultMessage
            }
        case let error as ErrorHandler.Errors:
            switch error {
            default:
                message = defaultMessage
            }
        default:
            print(error)
            return defaultMessage
        }
        return message
    }
}
