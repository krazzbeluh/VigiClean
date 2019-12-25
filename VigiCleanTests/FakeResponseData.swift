//
//  FakeResponseData.swift
//  VigiCleanTests
//
//  Created by Paul Leclerc on 23/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import FirebaseFirestore

class FakeResponseData {
    static let fakeValidObject: [String: Any] = [
        "coords": GeoPoint(latitude: 49.9219, longitude: 1.0811),
        "name": "Gare SNCF",
        "organization": "Dieppe",
        "type": "Poubelle"
    ]
    
    static let fakeActions: [String: String] = [
        "1": "La poubelle est pleine",
        "2": "La poubelle est endommagée"
    ]
    
    static let fakeEmployeeActions: [String: String] = [
        "1": "Vider la poubelle",
        "2": "Réparer la poubelle"
    ]
}
