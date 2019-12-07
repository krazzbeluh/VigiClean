//
//  DashboardViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class DashboardPresenter: DashboardViewPresenter {
    weak var view: DashboardView!
    
    required init(view: DashboardView) {
        self.view = view
    }
    
}
