//
//  LaunchContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 06/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol LaunchViewPresenter {
    init(view: LaunchView)
    var accountManager: AccountManager { get }
}

protocol LaunchView: class {
    
}
