//
//  ForecastRequest.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

struct ForecastRequest: Request, JSONBuildableRequest, SendableRequest, JSONParsing {
    
    typealias JSONType = Forecast
    
    var baseUrl: NSURL?
    
    var path: String
    
    var parameters: [String : AnyObject] = ["APPID": "5af4c3629c715e12a0f1c4048e017a22"]
    
    init(location: CLLocation) {
        self.init(latitude: location.coordinate.latitude,
                  longitude: location.coordinate.longitude)
    }
    
    init(latitude: Double, longitude: Double) {
        baseUrl = NSURL(string: "https://api.openweathermap.org")
        path = "/data/2.5/forecast"
        parameters["lat"] = latitude
        parameters["lon"] = longitude
    }
}