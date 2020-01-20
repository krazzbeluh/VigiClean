//
//  FirebaseInterfaces.swift
//  VigiClean
//
//  Created by Paul Leclerc on 12/01/2020.
//  Copyright © 2020 Paul Leclerc. All rights reserved.
//

import Foundation

// Contains every reusable strings used in database. Prevents hardcoded Strings
enum FirestoreCollection: String {
    case marketplace = "Marketplace"
    case object = "Object"
    case actions = "Actions"
    case performedActions = "PerformedActions"
    case request = "Request"
    case user = "User"
    
    enum FirestoreField: String {
        case partner
        case title
        case littleText
        case description
        case image
        case url
        case price
        case coords
        case organization
        case type
        case name
        case code
        case action
        case date
        case user
        case isValidOperation
        case credits
        case username
        case employedAt
    }
}

enum FunctionsFields: String {
    case saleCode
}
