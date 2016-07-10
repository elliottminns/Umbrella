//
//  WeatherRequest.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherRequest: OpenWeatherRequest, JSONBuildableRequest, SendableRequest, JSONParsing {
    
    typealias JSONType = Weather
    
    let endpoint: String = "/weather"
    
    let longitude: Double
    
    let latitude: Double
    
    let count = 1
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}