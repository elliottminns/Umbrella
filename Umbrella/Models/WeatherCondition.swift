//
//  WeatherCondition.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

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
    
    var stringValue: String {
        switch self {
        case .Thunderstorm: return "Thunderstorm"
        case .Drizzle: return "Drizzle"
        case .Rain: return "Rain"
        case .Snow: return "Snow"
        case .Atmosphere: return "Atmosphere"
        case .Clear: return "Clear"
        case .Clouds: return "Clouds"
        case .Extreme: return "Extreme"
        case .Additional(let s): return s
            
        }
    }
}

extension WeatherCondition: Equatable {}

func ==(lhs: WeatherCondition, rhs: WeatherCondition) -> Bool {
    return lhs.stringValue == rhs.stringValue
}

extension WeatherCondition: Hashable {
    var hashValue: Int {
        return stringValue.hash
    }
}