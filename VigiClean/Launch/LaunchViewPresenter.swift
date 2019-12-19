//
//  LaunchViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class LaunchPresenter: BasePresenter, LaunchViewPresenter {
    weak var view: LaunchView!
    
    required init(view: LaunchView) {
        self.view = view
    }
}
