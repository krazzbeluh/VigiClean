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
    
    weak var view: RequestView!
    
    required init(view: RequestView) {
        super.init()
        
        self.view = view
        
        guard let object = Object.currentObject else {
            fatalError("No object found when preparing request")
        }
        
        isUserEmployedAtObjectOrganization = VigiCleanUser.currentUser.employedAt == object.organization
        
        view.configure(with: object)
    }
    
    init(view: RequestView, objectManager: ObjectManager) {
        super.init()
        self.view = view
        self.objectManager = objectManager
    }
    
    var employeeMode = false
    var isUserEmployedAtObjectOrganization = false
    
    func switchEmployeeMode(to employeeMode: Bool) { // sets employeeMode for next methods
        self.employeeMode = employeeMode
    }
    
    var actions: [String] { // Returns actions based on employeeMode
        guard let object = Object.currentObject else {
            return [String]()
        }
        
        var actions = [String]()
        
        if !employeeMode {
            guard let userActions = object.actions else {
                view.displayError(message: convertError(ObjectManager.ObjectError.noActionsInObject))
                return actions
            }
            
            for index in 1 ... userActions.count {
                actions.append(userActions[index - 1].message)
            }
        } else {
            guard let employeeActions = object.employeeActions else {
                view.displayError(message: convertError(ObjectManager.ObjectError.noActionsInObject))
                return actions
            }
            
            for index in 1 ... employeeActions.count {
                actions.append(employeeActions[index - 1].message)
            }
        }
        
        return actions
    }
    
    func prepareMap() {  // prepares map settings to display object location
        guard let object = Object.currentObject else {
            return
        }
        let poi = Poi(title: "\(object.name) - \(object.organization)",
            coordinate: CLLocationCoordinate2D(latitude: object.coords.latitude,
                                               longitude: object.coords.longitude), info: object.type)
        view.configureMap(with: poi)
    }
    
    func sendRequest(with action: String, isValid: Bool) { // sends objectManager request based on employeeMode
        guard let object = Object.currentObject else {
            view.displayError(message: convertError(ObjectManager.ObjectError.objectNotFound))
            return
        }
        
        if !employeeMode {
            var sendingAction: Action?
            
            guard let actions = object.actions else {
                view.displayError(message: convertError(ObjectManager.ObjectError.actionNotFound))
                return
            }
            
            for act in actions where act.message == action {
                sendingAction = act
                break
            }
            
            guard let action = sendingAction else {
                self.view.displayError(message: convertError(UserError.unWantedValues))
                return
            }
            
            objectManager.sendRequest(for: object, with: action) { error in
                if let error = error {
                    self.view.displayError(message: self.convertError(error))
                    return
                }
                
                self.view.requestSent(employeeMode: false)
            }
        } else {
            var sendingAction: Action?
            
            guard let employeeActions = object.employeeActions else {
                view.displayError(message: convertError(ObjectManager.ObjectError.actionNotFound))
                return
            }
            
            for act in employeeActions where act.message == action {
                sendingAction = act
                break
            }
            
            guard let action = sendingAction else {
                self.view.displayError(message: convertError(UserError.unWantedValues))
                return
            }
            
            objectManager.resolvedRequest(for: object, with: action, isValid: isValid) { (error) in
                if let error = error {
                    self.view.displayError(message: self.convertError(error))
                }
                
                self.view.requestSent(employeeMode: true)
            }
        }
    }
}
