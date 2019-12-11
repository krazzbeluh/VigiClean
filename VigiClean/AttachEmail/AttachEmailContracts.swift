//
//  AttachEmailContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 27/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol AttachEmailView: AlertManager {
    func sendAlert(message: String)
    func switchActivityIndicator(hidden: Bool)
    func emailAttached()
}

protocol AttachEmailViewPresenter {
    init(view: AttachEmailView)
    func attachEmail(username: String?, email: String?, password: String?, confirmPassword: String?)
}