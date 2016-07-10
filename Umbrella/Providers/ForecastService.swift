//
//  ForecastService.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

class ForecastService {
    
    typealias Callback = ((result: Result<Forecast>) -> ())
    
    typealias Data = Forecast
    
    var locationService: LocationService?
    
    func get<T: Service where T.Data == CLLocation>(withLocationService locationService: T,
             callback: Callback) {
        
        locationService.get { (result) in
            
            switch result {
            case .Failure(let error):
                return callback(result: Result.Failure(error))
            case .Success(let location):
                self.forecast(forLocation: location, callback: callback)
            }
            
        }
    }
    
    private func forecast(forLocation location: CLLocation,
                                      callback: Callback) {
        let request = ForecastRequest(location: location)
        request.sendRequest { (result) in
            
            switch result {
            case .Failure(_): callback(result: result)
            case .Success(let forecast):
                self.getCurrentWeather(withLocation: location,
                    forForecast: forecast, callback: callback)
            }
        }
    }
    
    private func getCurrentWeather(withLocation location: CLLocation,
                                                forForecast forecast: Forecast,
                                                callback: Callback) {
        let request = WeatherRequest(location: location)
        request.sendRequest { (result) in
            switch result {
            case .Failure(let error):
                let res = Result<Forecast>.Failure(error)
                return callback(result: res)
            case .Success(let weather):
                var fore = forecast
                fore.weather.insert(weather, atIndex: 0)
                return callback(result: Result<Forecast>.Success(fore))
            }
        }
    }
}

extension ForecastService: Service {
    
    func get(callback: Callback) {
        let locationService = LocationService()
        get(withLocationService: locationService, callback: callback)
        self.locationService = locationService
    }
}