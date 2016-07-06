//
//  ForecastData.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
@testable import Umbrella

struct ForecastData: TestData {
    let json: String
    let weatherCount: Int
    let latitude: Double
    let longitude: Double
}

extension ResponseData {
    
    struct Forecast {
        
        static var London: ForecastData {
            let json = "{\"city\":{\"id\":2634341,\"name\":\"City of Westminster\",\"coord\":{\"lon\":-0.11667,\"lat\":51.5},\"country\":\"GB\",\"population\":0,\"sys\":{\"population\":0}},\"cod\":\"200\",\"message\":0.0048,\"cnt\":2,\"list\":[{\"dt\":1467838800,\"main\":{\"temp\":290,\"temp_min\":289.256,\"temp_max\":290,\"pressure\":1024.57,\"sea_level\":1034.5,\"grnd_level\":1024.57,\"humidity\":68,\"temp_kf\":0.74},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":64},\"wind\":{\"speed\":2.21,\"deg\":223.515},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2016-07-06 21:00:00\"},{\"dt\":1467849600,\"main\":{\"temp\":288.66,\"temp_min\":287.954,\"temp_max\":288.66,\"pressure\":1024.58,\"sea_level\":1034.42,\"grnd_level\":1024.58,\"humidity\":71,\"temp_kf\":0.7},\"weather\":[{\"id\":803,\"main\":\"Clouds\",\"description\":\"broken clouds\",\"icon\":\"04n\"}],\"clouds\":{\"all\":68},\"wind\":{\"speed\":3.87,\"deg\":230.001},\"sys\":{\"pod\":\"n\"},\"dt_txt\":\"2016-07-07 00:00:00\"}]}"
            
            return ForecastData(json: json, weatherCount: 2,
                                latitude: 51.5, longitude: -0.11667)
        }
    }
}