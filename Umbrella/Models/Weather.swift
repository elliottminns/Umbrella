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
    case Additional(String)
}

extension WeatherCondition {
    init(string: String) {
        switch string {
        case "Thunderstorm": self = .Thunderstorm
        case "Drizzle": self = .Drizzle
        case "Rain": self = .Rain
        case "Snow": self = .Snow
        case "Atmosphere": self = .Atmosphere
        case "Clear": self = .Clear
        case "Clouds": self = .Clouds
        case "Extreme": self = .Extreme
        default: self = .Additional(string)
        }
    }
}

struct Weather {
    let start: NSDate
    let end: NSDate
    let condition: WeatherCondition
    let description: String
    let temperature: Temperature
}

extension Weather: JSONConstructable {
    
    init?(data: [String: AnyObject]) {
        
        guard let timestamp = data["dt"] as? Int,
            weathers = data["weather"] as? [[String: AnyObject]],
            details = data["main"] as? [String: AnyObject],
            temp = details["temp"] as? Double,
            weather = weathers.first,
            cond = weather["main"] as? String,
            description = weather["description"] as? String else {
            return nil
        }
        
        
        let end = NSDate(timeIntervalSince1970: NSTimeInterval(timestamp))
        let start = end.dateByAddingTimeInterval(-3600 * 3)
        let condition = WeatherCondition(string: cond)
        let temperature = Temperature(value: temp, type: .Kelvin)
        
        self = Weather(start: start,
                       end: end,
                       condition: condition,
                       description: description,
                       temperature: temperature)
    }
    
}