//
//  VigiCleanUser.swift
//  VigiClean
//
//  Created by Paul Leclerc on 19/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct VigiCleanUser {
    enum NotificationType: String {
        case avatar = "AvatarChanged"
        case score = "ScoreChanged"
    }
    
    static var currentUser = VigiCleanUser(username: nil)
    
    var auth = Auth.auth()
    var database = Firestore.firestore()
    
    var user: User? {
        return auth.currentUser
    }
    
    var isConnected: Bool {
        VigiCleanUser.currentUser.user != nil
    }
    
    var isConnectedWithEmail: Bool {
        VigiCleanUser.currentUser.user?.email != nil
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.createUser(
            withEmail: email,
            password: password) { (_, error) in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) {
        auth.signIn(
            withEmail: email,
            password: password) { (_, error) in
                guard let error = error else {
                    completion(nil)
                    return
                }
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
        }
    }
    
    func anonymousSignIn(completion: @escaping((Error?) -> Void)) {
        auth.signInAnonymously { (_, error) in
            guard let error = error else {
                completion(nil)
                return
            }
            let errCode = ErrorHandler().convertToAuthError(error)
            completion(errCode)
        }
    }
    
    func attachEmail(email: String,
                     password: String,
                     completion: @escaping ((Error?) -> Void)) {
        VigiCleanUser.currentUser.user?.updateEmail(to: email) { (error) in
            guard error == nil else {
                let errCode = ErrorHandler().convertToAuthError(error!)
                completion(errCode)
                return
            }
            completion(nil)
        }
    }
    
    func updatePassword(password: String, completion: @escaping ((Error?) -> Void)) {
        VigiCleanUser.currentUser.user?.updatePassword(to: password) { (error) in
            guard error == nil else {
                let errCode = ErrorHandler().convertToAuthError(error!)
                completion(errCode)
                return
            }
            completion(nil)
        }
    }
    
    func updatePseudo(to newPseudo: String, with password: String, completion: @escaping (Error?) -> Void) {
        guard let uid = VigiCleanUser.currentUser.user?.uid else {
            completion(AccountManager.UAccountError.userNotLoggedIn)
            return
        }
        
        reauthenticate(password: password) { (error) in
            if let error = error {
                completion(error)
            } else {
                self.database.collection("User").document(uid).updateData([
                    "username": newPseudo
                ]) { error in
                    if let error = error {
                        let errCode = ErrorHandler().convertToFirestoreError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func updateEmail(to newEmail: String, with password: String, completion: @escaping (Error?) -> Void) {
        reauthenticate(password: password) { (error) in
            if let error = error {
                completion(error)
            } else {
                VigiCleanUser.currentUser.user?.updateEmail(to: newEmail, completion: { (error) in
                    if let error = error {
                        let errCode = ErrorHandler().convertToAuthError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                })
            }
        }
    }
    
    func updatePassword(to newPassword: String, from oldPassword: String, completion: @escaping (Error?) -> Void) {
        reauthenticate(password: oldPassword) { (error) in
            if let error = error {
                completion(error)
            } else {
                VigiCleanUser.currentUser.user?.updatePassword(to: newPassword) { (error) in
                    if let error = error {
                        let errCode = ErrorHandler().convertToAuthError(error)
                        completion(errCode)
                        return
                    }
                    completion(nil)
                }
            }
        }
    }
    
    func signOut(completion: @escaping (Error?) -> Void) {
        if !isConnectedWithEmail {
            VigiCleanUser.currentUser.user?.delete(completion: { (error) in
                if let error = error {
                    completion(ErrorHandler().convertToAuthError(error))
                } else {
                    completion(nil)
                }
            })
        } else {
            do {
                try auth.signOut()
            } catch let error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
            VigiCleanUser.currentUser.avatar = nil
            completion(nil)
        }
    }
    
    init(username: String?) {
        self.username = username
    }
    
    var username: String?
    var credits: Int = 0 {
        didSet {
            sendNotification(for: .score)
        }
    }
    var employedAt: String?
    
    var isEmployee: Bool {
        return employedAt != nil
    }
    
    var avatar: Data? {
        didSet {
            sendNotification(for: .avatar)
        }
    }
    
    private func sendNotification(for type: NotificationType) {
        let name = Notification.Name(rawValue: type.rawValue)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }

    func reauthenticate(password: String, completion: @escaping (Error?) -> Void) {
        guard let email = VigiCleanUser.currentUser.user?.email else {
            completion(AccountManager.UAccountError.userNotLoggedIn)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        VigiCleanUser.currentUser.user?.reauthenticate(with: credential) { (_, error) in
            if let error = error {
                let errCode = ErrorHandler().convertToAuthError(error)
                completion(errCode)
                return
            }
            
            completion(nil)
        }
    }
}
