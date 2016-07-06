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

class ForecastServiceMock {
    
    var getWeatherCalled: Bool
    
    var result: Result<Forecast>
    
    convenience init() {
        let forecast = Forecast(data: ResponseData.Forecast.London.jsonData)!
                              
        let res = Result.Success(forecast)
        self.init(result: res)
    }
    
    init(result: Result<Forecast>) {
        self.result = result
        self.getWeatherCalled = false
    }
}

extension ForecastServiceMock: Service {
    
    func get(callback: (result: Result<Forecast>) -> ()) {
        getWeatherCalled = true
        callback(result: result)
    }
    
}
