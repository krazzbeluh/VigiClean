//
//  WelcomeContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 27/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol WelcomeViewPresenter {
    init(view: WelcomeView)
    func signIn()
}

protocol WelcomeView: BaseView {
    func performSegue()
}
