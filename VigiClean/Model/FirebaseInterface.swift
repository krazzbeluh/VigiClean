//
//  FirebaseInterface.swift
//  VigiClean
//
//  Created by Paul Leclerc on 09/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFunctions

class FirebaseInterface {
    enum FIRInterfaceError: Error {
        case documentDoesNotExists, unableToDecodeData, unableToDecodeError
    }
}

extension FunctionsErrorCode: Error {
    
}
