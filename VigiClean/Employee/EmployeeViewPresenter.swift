//
//  EmployeeViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 08/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class EmployeePresenter: EmployeeViewPresenter {
    weak var view: EmployeeView!
    
    var objects: [Object]?
    
    private var objectManager = ObjectManager()
    
    required init(view: EmployeeView) {
        self.view = view
    }
    
    func getObjectList() {
        objectManager.getObjectList { (result) in
            switch result {
            case .success(let objects):
                self.objects = objects
                self.view.reloadTableView()
            case .failure(let error):
                print(error)
            }
        }
    }
}
