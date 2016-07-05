//
//  WeatherService.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

protocol WeatherService {
    func getWeather(callback: (result: Result<Weather>) -> ())
}