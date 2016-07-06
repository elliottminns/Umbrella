//
//  WeatherServiceMock.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Umbrella

class WeatherServiceMock {
    
    var getWeatherCalled: Bool
    
    var result: Result<Weather>
    
    convenience init() {
        let temp = Temperature(value: 10, type: .Celsius)
        let weather = Weather(start: NSDate(),
                              end: NSDate(), condition: .Rain, description: "",
                              temperature: temp)
                              
        let res = Result.Success(weather)
        self.init(result: res)
    }
    
    init(result: Result<Weather>) {
        self.result = result
        self.getWeatherCalled = false
    }
}

extension WeatherServiceMock: Service {
    
    func get(callback: (result: Result<Weather>) -> ()) {
        getWeatherCalled = true
        callback(result: result)
    }
    
}
