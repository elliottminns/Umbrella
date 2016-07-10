//
//  Weather.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

struct Weather {
    let start: NSDate
    let end: NSDate
    let condition: WeatherCondition
    let description: String
    let temperature: Temperature
    let icon: WeatherIcon?
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
        
        
        let start = NSDate(timeIntervalSince1970: NSTimeInterval(timestamp))
        let end = start.dateByAddingTimeInterval(3600 * 3)
        let condition = WeatherCondition(string: cond)
        let temperature = Temperature(value: temp, type: .Kelvin)
        
        let weatherIcon: WeatherIcon?
        if let icon = weather["icon"] as? String {
            weatherIcon = WeatherIcon(string: icon)
        } else {
            weatherIcon = nil
        }
        
        self = Weather(start: start,
                       end: end,
                       condition: condition,
                       description: description,
                       temperature: temperature,
                       icon: weatherIcon)
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

