//
//  ProfileViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol ProfileViewPresenter {
    init(view: ProfileView)
}

class ProfilePresenter: ProfileViewPresenter {
    unowned let view: ProfileView
    
    required init(view: ProfileView) {
        self.view = view
    }
}
