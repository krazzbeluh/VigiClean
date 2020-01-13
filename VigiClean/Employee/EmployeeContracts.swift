//
//  EmployeeContracts.swift
//  VigiClean
//
//  Created by Paul Leclerc on 08/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

protocol EmployeeViewPresenter: BasePresenter {
    var objects: [Object]? { get }
    init(view: EmployeeView)
    func getObjectList()
}

protocol EmployeeView: BaseView {
    func reloadTableView()
}
