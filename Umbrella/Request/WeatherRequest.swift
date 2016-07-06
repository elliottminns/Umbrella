//
//  WeatherRequest.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

struct WeatherRequest: Request, JSONBuildableRequest, SendableRequest, JSONParsing {
    
    typealias JSONType = Weather
    
    var baseUrl: NSURL?
    
    var path: String
    
    var parameters: [String : AnyObject] = ["APPID": "5af4c3629c715e12a0f1c4048e017a22"]
    
    init() {
        baseUrl = NSURL(string: "api.openweathermap.org")
        path = "/data/2.5/forecast"
    }
}