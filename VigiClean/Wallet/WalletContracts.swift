//
//  WalletContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 15/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

protocol WalletViewPresenter: BasePresenter {
    init(view: WalletView)
    func getUserSales()
    var sales: [Sale] { get }
}

protocol WalletView: BaseView {
    func gottenResponse()
}
