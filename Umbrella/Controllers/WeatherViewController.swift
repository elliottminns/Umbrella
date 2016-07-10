//
//  WeatherViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet var tableViewContainer: UIView?
    
    let service: ForecastService = ForecastService()
    
    var forecast: Forecast? {
        didSet {
            tableViewController?.forecast = forecast
            showTableView()
        }
    }
    
    var tableViewController: WeatherTableViewController? {
        didSet {
            tableViewController?.delegate = self
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Defaults.Color.Blue.base
        
        let addObs = NSNotificationCenter.defaultCenter().addObserverForName
        addObs(UIApplicationDidBecomeActiveNotification, object: nil,
               queue: nil) { (notification) in
                self.getForecast(fromService: self.service)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        LoadingView.show()
        getForecast(fromService: service)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if let vc = segue.destinationViewController as? WeatherTableViewController {
            tableViewController = vc
        }
    }
    
    func showTableView() {
        guard let tableViewContainer = tableViewContainer else { return }
        if (tableViewContainer.hidden) {
            tableViewContainer.alpha = 0.0
            tableViewContainer.hidden = false
            UIView.animateWithDuration(0.3, animations: { 
                tableViewContainer.alpha = 1.0
            })
        }
    }
}

extension WeatherViewController {
    func getForecast<T: Service where T.Data == Forecast>(fromService service: T) {
        service.get { [weak self] (result) in
            
            LoadingView.dismiss()
            
            switch result {
            case .Success(let forecast):
                self?.forecast = forecast
            case .Failure(let error):
                self?.handle(error: error)
            }
        }
    }
}

// MARK: - Error Handling
extension WeatherViewController {

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

extension WeatherViewController: WeatherTableViewControllerDelegate {
    func controllerWantsToRefresh(controller: WeatherTableViewController) {
        getForecast(fromService: service)
    }
}
