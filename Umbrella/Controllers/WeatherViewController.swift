//
//  WeatherViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var weather: Weather?
    
    func getWeather<T: Service where T.Data == Weather>(fromService service: T) {
        service.get { [weak self] (result) in
            switch result {
            case .Success(let weather):
                self?.weather = weather
            case .Failure(let error):
                break;
            }
        }
    }
    
}
