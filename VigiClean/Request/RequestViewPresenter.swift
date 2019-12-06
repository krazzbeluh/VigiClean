//
//  RequestViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation

class RequestPresenter: BasePresenter, RequestViewPresenter {
    
    let objectManager = ObjectManager()
    
    var actions: [String] {
        guard let object = Object.currentObject else {
            return ["1 - autre"]
        }
        
        var actions = [String]()
        
        for index in 1 ... object.actions.count {
            actions.append("\(index) - \(object.actions[index - 1])")
        }
        
        actions.append("\(actions.count + 1) - Autre")
        
        return actions
    }
    
    weak var view: RequestView!
    
    required init(view: RequestView) {
        self.view = view
        
        guard let object = Object.currentObject else {
            fatalError("No object found when preparing request")
        }
        
        view.configure(with: object)
    }
    
    func sendRequest(with action: String) {
        
        guard let object = Object.currentObject else {
            return
        }
        
        objectManager.sendRequest(for: object, with: action) { error in
            if let error = error {
                self.view.sendAlert(message: self.convertAlert(with: error))
                return
            }
            
            self.view.requestSent()
        }
    }
}
