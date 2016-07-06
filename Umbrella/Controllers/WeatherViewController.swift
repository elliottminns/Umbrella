//
//  WeatherViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    var forecast: Forecast?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Defaults.Color.Blue.base
    }
    
    func getForecast<T: Service where T.Data == Forecast>(fromService service: T) {
        service.get { [weak self] (result) in
            switch result {
            case .Success(let forecast):
                self?.forecast = forecast
            case .Failure(let error):
                break;
            }
        }
    }
    
}
