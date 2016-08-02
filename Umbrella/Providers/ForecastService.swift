//
//  ForecastService.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

extension Service where Data == Forecast {
    
    typealias Callback = ((result: Result<Forecast>) -> ())
    
    func forecast(forLocation location: CLLocation,
                                      callback: Callback) {
        let request = ForecastRequest(location: location)
        request.sendRequest { [weak self] (result) in
            
            switch result {
            case .Failure(_): callback(result: result)
            case .Success(let forecast):
                self?.getCurrentWeather(withLocation: location,
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

class ForecastService {
    
    typealias Callback = ((result: Result<Forecast>) -> ())
    
    typealias Data = Forecast
    
    let locationService: LocationService = LocationService()
    
    private var active = false
    
    func get<T: Service where T.Data == CLLocation>(withLocationService locationService: T,
             callback: Callback) {
        
        locationService.get { [weak self] (result) in
            
            switch result {
            case .Failure(let error):
                return callback(result: Result.Failure(error))
            case .Success(let location):
                self?.forecast(forLocation: location, callback: callback)
            }
            
        }
    }
}

extension ForecastService: Service {
    
    func get(callback: Callback) {
        
        let arguments = NSProcessInfo.processInfo().arguments
        
        if arguments.contains("MOCK_NO_INTERNET") {
            let error = RequestError(message: "No Internet")
            let result = Result<Forecast>.Failure(error)
            return callback(result: result)
        }
        
        if (!active) {
            active = true
            get(withLocationService: locationService) { [weak self] result in
                self?.active = false
                callback(result: result)
            }
        }
    }
}