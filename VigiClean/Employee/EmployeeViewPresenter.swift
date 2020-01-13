//
//  EmployeeViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 08/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

class EmployeePresenter: BasePresenter, EmployeeViewPresenter {
    weak var view: EmployeeView!
    
    var objects: [Object]?
    
    private var objectManager = ObjectManager()
    
    required init(view: EmployeeView) {
        self.view = view
    }
    
    init(view: EmployeeView, objectManager: ObjectManager? = nil) {
        self.view = view
        self.objectManager = objectManager ?? ObjectManager()
    }
    
    func getObjectList() {
        objectManager.getObjectList { (result) in
            switch result {
            case .success(let objects):
                self.objects = objects
                self.view.reloadTableView()
            case .failure(let error):
                self.view.displayError(message: self.convertError(error))
            }
        }
    }
}
