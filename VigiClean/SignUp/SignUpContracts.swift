//
//  SignUpContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 27/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol SignUpView: BaseView {
    func switchActivityIndicator(hidden: Bool)
    func userSignedUp()
}

protocol SignUpViewPresenter {
    init(view: SignUpView)
    func signUp(username: String?, email: String?, password: String?, confirmPassword: String?)
}
