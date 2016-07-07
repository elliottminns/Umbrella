//
//  LocationService.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import CoreLocation

struct LocationService {
    typealias Data = CLLocation
}

extension LocationService: Service {
    func get(callback: (result: Result<Data>) -> ()) {
        
    }
}

