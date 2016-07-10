//
//  OpenWeatherRequest.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

protocol OpenWeatherRequest: Request {
    var endpoint: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var count: Int { get }
    init(latitude: Double, longitude: Double)
}

extension OpenWeatherRequest {
    
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude)
    }
    
    var baseUrl: NSURL? {
        return NSURL(string: "http://api.openweathermap.org")
    }
    
    var path: String {
        let prefix = endpoint.characters.first == "/" ? "" : "/"
        return "/data/2.5" + prefix + endpoint
    }
    
    var parameters: [String : AnyObject] {
        return [
            "APPID": ConfigurationManager.sharedManager.openWeatherMapToken,
            "lat": latitude,
            "lon": longitude,
            "cnt": count
        ]
    }
}