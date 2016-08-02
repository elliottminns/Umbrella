//
//  CityForecastService.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

class CityForecastService {
    
    typealias Data = Forecast
    
    let city: City
    
    init(city: City) {
        self.city = city
    }
}

extension CityForecastService: Service {
    
    func get(callback: (result: Result<Data>) -> ()) {
        let location = city.location
        self.forecast(forLocation: location, callback: callback)
    }
    
}