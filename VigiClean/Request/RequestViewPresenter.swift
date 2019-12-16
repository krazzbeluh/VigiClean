//
//  RequestViewPresenter.swift
//  VigiClean
//
//  Created by Paul Leclerc on 02/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import MapKit

class RequestPresenter: BasePresenter, RequestViewPresenter {
    let accountManager = AccountManager()
    let objectManager = ObjectManager()
    
    var employeeMode = false
    
    func switchEmployeeMode(to employeeMode: Bool) {
        self.employeeMode = employeeMode
    }
    
    var actions: [String] {
        guard let object = Object.currentObject else {
            return ["Autre"]
        }
        
        var actions = [String]()
        
        if !employeeMode {
            for index in 1 ... object.actions.count {
                actions.append(object.actions[index - 1].message)
            }
        } else {
            for index in 1 ... object.employeeActions.count {
                actions.append(object.employeeActions[index - 1].message)
            }
        }
        
        actions.append("Autre")
        
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
    
    func fetchRole(callback: @escaping (Bool) -> Void) {
        accountManager.fetchRole { result in
            switch result {
            case .success(let isEmployee):
                callback(isEmployee)
            case .failure(let error):
                print(error)
                callback(false)
            }
        }
    }
    
    func prepareMap() {
        guard let object = Object.currentObject else {
            return
        }
        let sanjose = Poi(title: "\(object.name) - \(object.organization)",
            coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                               longitude: object.coords.longitude), info: object.type)
        view.configureMap(with: sanjose)
    }
    
    func sendRequest(with action: String, isValid: Bool) {
        
        guard let object = Object.currentObject else {
            return
        }
        
        if !employeeMode {
            var sendingAction: Action?
            for act in object.actions where act.message == action {
                sendingAction = act
                break
            }
            
            guard let action = sendingAction else {
                return
            }
            
            objectManager.sendRequest(for: object, with: action) { error in
                if let error = error {
                    self.view.sendAlert(message: self.convertAlert(with: error))
                    return
                }
                
                self.view.requestSent()
            }
        } else {
            var sendingAction: Action?
            for act in object.employeeActions where act.message == action {
                sendingAction = act
                break
            }
            
            guard let action = sendingAction else {
                return
            }
            
            objectManager.resolvedRequest(for: object, with: action, isValid: isValid) { (error) in
                if let error = error {
                    self.view.sendAlert(message: self.convertAlert(with: error))
                    return
                }
                
            }
        }
        
    }
}
