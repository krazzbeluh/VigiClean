//
//  ProfileViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 18/11/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class ProfilePresenter: ProfileViewPresenter {
    weak let view: ProfileView
    
    required init(view: ProfileView) {
        self.view = view
    }
}
