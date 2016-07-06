//
//  ResponseData.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
@testable import Umbrella

struct WeatherData: TestData {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let description: String
    let end: NSDate
    let start: NSDate
    let main: WeatherCondition
    let json: String
}

struct ResponseData {
    
    struct Weather {
        
        static var Rain: WeatherData {
            
            let json = "{\"dt\":1467774000,\"main\":{\"temp\":281.15,\"temp_min\":281.15,\"temp_max\":282.551,\"pressure\":1025.6,\"sea_level\":1035.62,\"grnd_level\":1025.6,\"humidity\":84,\"temp_kf\":-1.4},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"clouds\":{\"all\":0},\"wind\":{\"speed\":3.46,\"deg\":327.502},\"rain\":{\"3h\":0.7725},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2016-07-06 03:00:00\"}"
            
            return WeatherData(temp: 281.15,
                               tempMin: 281.15,
                               tempMax: 282.551,
                               description: "light rain",
                               end: NSDate(timeIntervalSince1970: 1467774000),
                               start: NSDate(timeIntervalSince1970: 1467774000 - 3600 * 3),
                               main: .Rain,
                               json: json)
        }
        
    }
}