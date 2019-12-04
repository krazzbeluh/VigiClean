//
//  RequestContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol RequestViewPresenter {
    init(view: RequestView)
    var actions: [String] { get }
    func sendRequest(with action: String)
}

protocol RequestView: class {
    func configure(with object: Object)
    func showAlert(with type: Error)
    func requestSent()
}
