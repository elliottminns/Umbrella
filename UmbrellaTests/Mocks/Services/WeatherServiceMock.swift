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
        let location = CLLocation(latitude: 0, longitude: 0)
        let weather = Weather(location: location, start: NSDate(),
                              end: NSDate(), condition: .Rain, description: "")
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
