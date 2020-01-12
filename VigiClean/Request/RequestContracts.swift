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
    var isUserEmployedAtObjectOrganization: Bool { get }
    func sendRequest(with action: String, isValid: Bool)
    func switchEmployeeMode(to employeeMode: Bool)
    func prepareMap()
}

protocol RequestView: BaseView {
    func configure(with object: Object)
    func configureMap(with location: Poi)
    func requestSent(employeeMode: Bool)
}
