//
//  ProfileContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 27/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol ProfileViewPresenter: BasePresenter {
    init(view: ProfileView)
    var isConnectedAnonymously: Bool { get }
    func signOut()
    func updatePseudo(to newPseudo: String?, with password: String?)
    func updateEmail(to newEmail: String?, with password: String?)
    func updateAvatar(to newAvatar: Data, with password: String?)
    func updatePassword(to newPassword: String?, confirm: String?, with password: String?)
}

protocol ProfileView: BaseView {
    func userSignedOut()
    func display(username: String)
    func display(email: String)
    func display(avatar: Data)
    func passwordChanged()
}
