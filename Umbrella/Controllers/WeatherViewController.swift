//
//  WeatherViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var tableViewContainer: UIView?
    
    @IBOutlet weak var loadingLabel: UILabel?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView?
    
    @IBOutlet weak var retryButton: UIButton?
    
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
        
        loadingLabel?.font = Defaults.Fonts.Normal.font
        loadingLabel?.textColor = Defaults.Color.Secondary.base
        
        view.backgroundColor = Defaults.Color.Primary.base
        
        retryButton?.backgroundColor = Defaults.Color.Secondary.base
        retryButton?.setTitleColor(Defaults.Color.Primary.base,
                                   forState: [.Normal, .Highlighted])
        retryButton?.layer.cornerRadius = 5.0
        
        
        let addObs = NSNotificationCenter.defaultCenter().addObserverForName
        let queue = NSOperationQueue.mainQueue()
        addObs(UIApplicationDidBecomeActiveNotification, object: nil,
               queue: queue) { (notification) in
                self.getForecast(fromService: self.service)
        }
    }
    
    func displayLoading() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if tableViewContainer?.hidden == true {
            loadingLabel?.hidden = false
            loadingLabel?.text = "Loading Weather"
            loadingIndicator?.startAnimating()
            retryButton?.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
    func getForecast<T: Service where T.Data == Forecast>(fromService service: T) {
        
        displayLoading()
        
        service.get { [weak self] (result) in
            
            switch result {
            case .Success(let forecast):
                self?.hideLoadingViews()
                self?.forecast = forecast
            case .Failure(let error):
                self?.handle(error: error)
            }
        }
    }
    
    func showAlert(title title: String, message: String, actions: [UIAlertAction]) {
        
        let alert = UIAlertController(title: title, message: message,
                                      preferredStyle: .Alert)
        actions.forEach { action in
            alert.addAction(action)
        }
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func displayRetry() {
        
        loadingIndicator?.stopAnimating()
        
        if tableViewContainer?.hidden == true {
            loadingLabel?.text = "Could not load weather"
            loadingLabel?.hidden = false
            retryButton?.hidden = false
        }
        
    }
}

// MARK: - Actions
extension WeatherViewController {
    @IBAction func retryButtonPressed(sender: UIButton) {
        getForecast(fromService: service)
    }
}

extension WeatherViewController {
    
    func hideLoadingViews() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        UIView.animateWithDuration(0.1, animations: {
            self.loadingIndicator?.alpha = 0.0
            self.loadingLabel?.alpha = 0.0
            }) { complete in
                self.loadingIndicator?.stopAnimating()
                self.loadingLabel?.hidden = true
                self.loadingIndicator?.alpha = 1.0
                self.loadingLabel?.alpha = 1.0
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
        }
       
        displayRetry()
    }
    
    func handle(error error: RequestError) {
        let title = "Could not load weather data"
        let message = "Please check your internet settings and try again"
        let dismiss = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        showAlert(title: title, message: message, actions: [dismiss])
    }
    
    func handle(error error: LocationServiceError) {
        
        let title: String
        let message: String
        let showSettings: Bool
        
        switch error {
        case .LocationDenied:
            title = "Location Denied"
            message = "Please allow your location for us to proivde you weather forecasts"
            showSettings = true
        case .LocationFailed:
            title = "Location Failed"
            message = "We could not discover your location, please try again"
            showSettings = false
        case .LocationRestricted:
            title = "Location Restricted"
            message = "Please check your settings to unrestrict location access"
            showSettings = true
        }
        
        var actions: [UIAlertAction] = []
        
        let dismiss = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
        actions.append(dismiss)
        
        if showSettings {
            let show = UIAlertAction(title: "Settings", style: .Default) { alert in
                let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            actions.append(show)
        }
        
        showAlert(title: title, message: message, actions: actions)
    }
}

extension WeatherViewController: WeatherTableViewControllerDelegate {
    func controllerWantsToRefresh(controller: WeatherTableViewController) {
        getForecast(fromService: service)
    }
}
