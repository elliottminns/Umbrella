//
//  WeatherIcon.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

enum WeatherIcon {
    case ClearSkyDay
    case ClearSkyNight
    case Rain
    case CloudyDay
    case CloudyNight
    case Overcast
    case Thunderstorm
    case Snow
    case Mist
}

extension WeatherIcon {
    init?(string: String) {
        switch string {
        case "01d": self = .ClearSkyDay
        case "01n": self = .ClearSkyNight
        case "02d": self = .CloudyDay
        case "02n": self = .CloudyNight
        case "03d", "03n", "04d", "04n": self = .Overcast
        case "09d", "09n", "10d", "10n": self = .Rain
        case "11d", "11n": self = .Thunderstorm
        case "13d", "13n": self = .Snow
        case "50d", "50n": self = .Mist
        default: return nil
        }
    }
}