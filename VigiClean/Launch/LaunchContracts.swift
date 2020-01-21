//
//  LaunchContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

// Protocols are contracts between view and presenter. Views and Presenters don't knows them
protocol LaunchViewPresenter: BasePresenter {
    init(view: LaunchView)
    var isUserConnected: Bool { get }
    func listenForUserDocumentChanges()
    func getAvatar()
}

protocol LaunchView: BaseView {
    func allResponseRecieved()
}
