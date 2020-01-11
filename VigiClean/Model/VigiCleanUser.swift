//
//  VigiCleanUser.swift
//  VigiClean
//
//  Created by Paul Leclerc on 19/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth

struct VigiCleanUser {
    enum NotificationType: String {
        case avatar = "AvatarChanged"
        case score = "ScoreChanged"
    }
    
    var auth = Auth.auth()
    
    var user: User? {
        return auth.currentUser
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
}
