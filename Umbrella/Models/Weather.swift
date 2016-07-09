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

extension SequenceType where Generator.Element == Weather {
    
    func elements(forHours hours: Int) -> [Weather] {
        let date = NSDate().dateByAddingTimeInterval(NSTimeInterval(hours * 3600))
        return filter {
            return $0.end.timeIntervalSinceNow > 0 && $0.end.timeIntervalSince1970 < date.timeIntervalSince1970
        }
    }
    
    func averageTemperature(inUnit unit: UnitTemperature) -> Temperature? {
        var count = 0
        let total: Double = reduce(0) {
            count += 1
            return $0.0 + $0.1.temperature.converted(to: unit).value
        }
        
        guard count > 0 else { return nil }
        
        let average = total / Double(count)
        return Temperature(value: average, type: unit)
    }
    
    func mostOccuringCondition() -> WeatherCondition? {
        
        let counts: [WeatherCondition: Int] = {
            var counts: [WeatherCondition: Int] = [:]
            forEach({ (w: Weather) in
                if let count = counts[w.condition] {
                    counts[w.condition] = count + 1
                } else {
                    counts[w.condition] = 1
                }
            })
            return counts
        }()
        
        var currentCount: Int?
        
        var highest: WeatherCondition?
        
        counts.forEach { (val: (condition: WeatherCondition, num: Int)) in
            if let count = currentCount {
                if val.num > count {
                    currentCount = val.num
                    highest = val.condition
                }
            } else {
                currentCount = val.num
                highest = val.condition
            }
        }
        
        return highest
    }
    
}

