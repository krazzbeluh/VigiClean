//
//  ListenerRegistrationFake.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 05/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore
@testable import VigiClean

class ListenerRegistrationFake: ListenerRegistration {
    func remove() {
        return
    }
    
    func isEqual(_ object: Any?) -> Bool {
        return true
    }
    
    var hash: Int = 0
    
    var superclass: AnyClass?
    
    func `self`() -> Self {
        return self
    }
    
    func perform(_ aSelector: Selector!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func perform(_ aSelector: Selector!, with object1: Any!, with object2: Any!) -> Unmanaged<AnyObject>! {
        return nil
    }
    
    func isProxy() -> Bool {
        return true
    }
    
    func isKind(of aClass: AnyClass) -> Bool {
        return true
    }
    
    func isMember(of aClass: AnyClass) -> Bool {
        return true
    }
    
    func conforms(to aProtocol: Protocol) -> Bool {
        return true
    }
    
    func responds(to aSelector: Selector!) -> Bool {
        return true
    }
    
    var description: String = ""
}
