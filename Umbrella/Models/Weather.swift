//
//  Weather.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

enum WeatherCondition {
    case Thunderstorm
    case Drizzle
    case Rain
    case Snow
    case Atmosphere
    case Clear
    case Clouds
    case Extreme
    case Additional
}

struct Weather {
    let location: CLLocation
    let start: NSDate
    let end: NSDate
    let condition: WeatherCondition
    let description: String
}