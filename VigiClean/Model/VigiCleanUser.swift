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
    var auth = Auth.auth()
    
    var user: User? {
        return auth.currentUser
    }
    
    init(username: String?) {
        self.username = username
    }
    
    var username: String?
    var credits: Int = 0
    var employedAt: String?
    
    var isEmployee: Bool {
        return employedAt != nil
    }
    
    var avatar: Data? {
        didSet {
            sendAvatarNotification()
        }
    }
    
    private func sendAvatarNotification() {
        let name = Notification.Name(rawValue: "AvatarChanged")
        let notification = Notification(name: name)
        NotificationCenter.default.post(notification)
    }
}
