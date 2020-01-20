//
//  Poi.swift
//  VigiClean
//
//  Created by Paul Leclerc on 14/12/2019.
//  Copyright © 2019 Paul Leclerc. All rights reserved.
//

import Foundation
import MapKit

// A POI is a point in the map. It's used when displaying maps
class Poi: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
