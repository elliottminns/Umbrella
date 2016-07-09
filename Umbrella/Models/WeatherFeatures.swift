//
//  WeatherFeatures.swift
//  Umbrella
//
//  Created by Elliott Minns on 08/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

struct WeatherFeatures {
    
    enum Temperature {
        case Freezing
        case Cold
        case Mild
        case Warm
        case Hot
    }
    
    enum Sky {
        case Overcast
        case Cloudy
        case Clear
    }
    
    enum Precipitation {
        case Snow
        case Hail
        case Rain
        case Fog
        case Dry
    }
    
    let temperature: Temperature
    let sky: Sky
    let precipitation: Precipitation
    
    init(weather: Weather) {
        self.sky = Sky(weather: weather)
        self.temperature = Temperature(temperature: weather.temperature)
        self.precipitation = Precipitation(weather: weather)
    }
    
    init?(weather: [Weather]) {
        guard let sky = Sky(weather: weather),
            averageTemp = weather.averageTemperature(inUnit: .Celsius),
            precip = Precipitation(weather: weather) else { return nil }
        
        self.sky = sky
        self.temperature = Temperature(temperature: averageTemp)
        self.precipitation = precip
    }
}

extension WeatherFeatures.Sky {
    
    init(condition: WeatherCondition) {
        switch condition {
        case .Clear: self = .Clear
        case .Clouds: self = .Cloudy
        case .Rain, .Drizzle, .Snow: self = .Overcast
        default: self = .Clear
        }
    }
    
    init(weather: Weather) {
        self.init(condition: weather.condition)
    }
    
    init?(weather: [Weather]) {
        guard let highest = weather.mostOccuringCondition() else {
            return nil
        }
        
        self.init(condition: highest)
    }
}

extension WeatherFeatures.Precipitation {
    
    init(weather: Weather) {
        self.init(condition: weather.condition)
    }
    
    init(condition: WeatherCondition) {
        switch condition {
        case .Thunderstorm, .Rain, .Drizzle: self = .Rain
        case .Snow: self = .Snow
        case .Atmosphere: self = .Fog
        default: self = .Dry
        }
    }
    
    init?(weather: [Weather]) {
        
        guard let highest = weather.mostOccuringCondition() else {
            return nil
        }
        
        self.init(condition: highest)
    }
}

extension WeatherFeatures.Temperature {
    
     init(temperature: Temperature) {
        let temp = temperature.converted(to: .Celsius).value
        
        if temp < 0 {
            self = .Freezing
        } else if temp < 10 {
            self = .Cold
        } else if temp < 20 {
            self = .Mild
        } else if temp < 30 {
            self = .Warm
        } else {
            self = .Hot
        }
    }
}