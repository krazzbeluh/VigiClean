//
//  DashboardContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol DashboardViewPresenter: BasePresenter {
    init(view: DashboardView)
    func getAvatar()
}

protocol DashboardView: BaseView {
    func setAvatar(with image: Data)
}
