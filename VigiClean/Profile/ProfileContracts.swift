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
}

protocol ProfileView: AlertManager {
    func userSignedOut()
}
