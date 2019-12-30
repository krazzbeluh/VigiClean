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
    private var objectManager = ObjectManager()
    private var accountManager = AccountManager()
    
    var employeeMode = false
    var isEmployee = false
    
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
        super.init()
        
        self.view = view
        
        guard let object = Object.currentObject else {
            fatalError("No object found when preparing request")
        }
        
        fetchRole()
        
        view.configure(with: object)
    }
    
    init(view: RequestView, objectManager: ObjectManager, accountManager: AccountManager) {
        super.init()
        self.view = view
        self.objectManager = objectManager
        self.accountManager = accountManager
    }
    
    func fetchRole() {
        accountManager.fetchRole { result in
            switch result {
            case .success(let isEmployee):
                self.isEmployee = isEmployee
                self.view.roleFetched()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func prepareMap() {
        guard let object = Object.currentObject else {
            return
        }
        let poi = Poi(title: "\(object.name) - \(object.organization)",
            coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                               longitude: object.coords.longitude), info: object.type)
        view.configureMap(with: poi)
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
                    self.view.displayError(message: self.convertError(error))
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
                    self.view.displayError(message: self.convertError(error))
                    return
                }
                self.view.requestSent()
            }
        }
        
    }
}
