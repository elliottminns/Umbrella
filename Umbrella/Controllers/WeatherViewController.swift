//
//  WeatherViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    let service: ForecastService = ForecastService()
    
    var forecast: Forecast? {
        didSet {
            self.locationLabel?.text = forecast?.placeName
            self.temperatureLabel?.text = forecast?.currentTemperature(inUnit: .Celsius)?.description
        }
    }
    
    @IBOutlet var locationLabel: UILabel?
    
    @IBOutlet var temperatureLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Defaults.Color.Blue.base
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getForecast(fromService: service)
    }
    
    func getForecast<T: Service where T.Data == Forecast>(fromService service: T) {
        service.get { [weak self] (result) in
            switch result {
            case .Success(let forecast):
                self?.forecast = forecast
            case .Failure(let error):
                self?.handle(error: error)
            }
        }
    }

    func handle(error error: ErrorType) {
        if let error = error as? LocationServiceError {
            handle(error: error)
        } else if let error = error as? RequestError {
            handle(error: error)
        } else {
            
        }
    }
    
    func handle(error error: RequestError) {
        
    }
    
    func handle(error error: LocationServiceError) {
        
    }
    
}
