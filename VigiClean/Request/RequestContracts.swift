//
//  RequestContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

protocol RequestViewPresenter: BasePresenter {
    init(view: RequestView)
    var actions: [String] { get }
    func sendRequest(with action: String, isValid: Bool)
    func fetchRole(callback: @escaping (Bool) -> Void)
    func switchEmployeeMode(to employeeMode: Bool)
    func prepareMap()
}

protocol RequestView: AlertManager {
    func configure(with object: Object)
    func sendAlert(message: String)
    func requestSent()
    func configureMap(with location: Poi)
}
