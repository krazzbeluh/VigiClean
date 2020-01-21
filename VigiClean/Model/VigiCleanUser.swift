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

// Manages and stores User Infos in RAM.
class VigiCleanUser {
    enum NotificationType: String { // Notifications to change values at multiple points at a time
        case avatar = "AvatarChanged"
        case score = "ScoreChanged"
    }
    
    init(username: String?) {
        self.username = username
    }
    
    static var currentUser = VigiCleanUser(username: nil)
    
    var auth = Auth.auth()
    var database = Firestore.firestore()
    
    var user: User? { // returns firebaseAuth currentUser
        return auth.currentUser
    }
    
    var isConnected: Bool {
        VigiCleanUser.currentUser.user != nil
    }
    
    var isConnectedWithEmail: Bool {
        VigiCleanUser.currentUser.user?.email != nil
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
    
    func signUp(username: String, email: String, password: String, completion: @escaping((Error?) -> Void)) {
        // registers user in database
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
    
    func signIn(email: String, password: String, completion: @escaping((Error?) -> Void)) { // signs user in app
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
    
    func anonymousSignIn(completion: @escaping((Error?) -> Void)) { // registers user as anonymous
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
                     completion: @escaping ((Error?) -> Void)) { // converts anonymous account into registered account
        VigiCleanUser.currentUser.user?.updateEmail(to: email) { (error) in
            guard error == nil else {
                let errCode = ErrorHandler().convertToAuthError(error!)
                completion(errCode)
                return
            }
            completion(nil)
        }
    }
    
    func createPassword(password: String, completion: @escaping ((Error?) -> Void)) {
        // creates password for attachEmail
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
        // updates pseudo in database
        guard let uid = VigiCleanUser.currentUser.user?.uid else {
            completion(AccountManager.UAccountError.userNotLoggedIn)
            return
        }
        
        reauthenticate(password: password) { (error) in
            if let error = error {
                completion(error)
            } else {
                self.database.collection(FirestoreCollection.user.rawValue).document(uid).updateData([
                    FirestoreCollection.FirestoreField.username.rawValue: newPseudo
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
        // updates email in auth
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
        // updates password in auth
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
    
    func signOut(completion: @escaping (Error?) -> Void) { // signs user out
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
    
    private func sendNotification(for type: NotificationType) {
        // sends notification to update datas at multiple points at a time
        let name = Notification.Name(rawValue: type.rawValue)
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }

    func reauthenticate(password: String, completion: @escaping (Error?) -> Void) {
        // reauthenticates user, verifies password
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
