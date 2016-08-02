//
//  City.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

struct City {
    
    let name: String
    let location: CLLocation
    
    init(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        self.init(name: name, location: location)
    }
    
    init(name: String, location: CLLocation) {
        self.name = name
        self.location = location
    }
}