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