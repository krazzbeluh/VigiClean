//
//  FirebaseInterface.swift
//  VigiClean
//
//  Created by Paul Leclerc on 03/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseInterface {
    enum FIRInterfaceError: Error {
        case unableToDecodeData, unableToDecodeError
    }
    
    static var auth = Auth.auth()
    static var database = Firestore.firestore()
}
