//
//  Temperature.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

enum UnitTemperature {
    case Kelvin
    case Farenheit
    case Celsius
}

struct Temperature {
    
    let value: Double
    
    let type: UnitTemperature
    
    init(value: Double, type: UnitTemperature) {
        self.value = value
        self.type = type
    }
    
    var description: String {
        let valString = "\(Int(round(value))) º"
        let symbol: String
        
        switch type {
        case .Celsius: symbol = "C"
        case .Farenheit: symbol = "F"
        case .Kelvin: symbol = "K"
        }
        
        return valString + symbol
    }
    
    func descriptionForLocale(locale: NSLocale) -> String {
        if let uses = locale.objectForKey(NSLocaleUsesMetricSystem) where
            uses.boolValue == true {
            
            return self.converted(to: .Celsius).description
        } else {
            return self.converted(to: .Farenheit).description
        }
    }
    
    func converted(to unit: UnitTemperature) -> Temperature {
        let convert = Temperature.convert(value, from: type, to: unit)
        return Temperature(value: convert, type: unit)
    }
    
    private static func convert(value: Double, from: UnitTemperature,
                                to: UnitTemperature) -> Double {
        
        guard from != to else {
            return value
        }
        
        let kelvin: Double
        
        let celsiusToKelvinDelta = 273.15
        let farenToKelDelta = 459.67
        
        switch from {
        case .Kelvin: kelvin = value
        case .Celsius: kelvin = value + celsiusToKelvinDelta
        case .Farenheit: kelvin = (value + farenToKelDelta) * (5 / 9)
        }
        
        switch to {
        case .Kelvin: return kelvin
        case .Celsius: return kelvin - celsiusToKelvinDelta
        case .Farenheit: return (kelvin * 1.8) - farenToKelDelta;
        }
    }
}

extension Temperature: Equatable {}

func ==(lhs: Temperature, rhs: Temperature) -> Bool {
    let lhsKelvin = lhs.converted(to: .Kelvin)
    let rhsKelvin = rhs.converted(to: .Kelvin)
    return round(lhsKelvin.value) == round(rhsKelvin.value)
}

