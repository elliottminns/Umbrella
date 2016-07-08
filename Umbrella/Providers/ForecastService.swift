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
        request.sendRequest(callback)
    }
}

extension ForecastService: Service {
    
    func get(callback: Callback) {
        let locationService = LocationService()
        get(withLocationService: locationService, callback: callback)
        self.locationService = locationService
    }
}