//
//  WeatherTableViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

protocol WeatherTableViewControllerDelegate: class {
    func controllerWantsToRefresh(controller: WeatherTableViewController)
}

class WeatherTableViewController: UITableViewController {
    
    var forecast: Forecast? {
        didSet {
            refreshControl?.endRefreshing()
            tableView.reloadData()
        }
    }
    
    weak var delegate: WeatherTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh),
                                  forControlEvents: .AllEvents)
    }
    
    func refresh() {
        guard let delegate = delegate else { return }
        refreshControl?.beginRefreshing()
        delegate.controllerWantsToRefresh(self)
    }
    
}


// MARK: - UITableViewDelegate
extension WeatherTableViewController {
    override func tableView(tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        
        guard let forecast = forecast else { return nil }
        return WeatherHeaderView(forecast: forecast)
    }
    
    override func tableView(tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        return 140
    }
    
    override func tableView(tableView: UITableView,
                            didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension WeatherTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return forecast == nil ? 0 : 1
    }
    
    override func tableView(tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let forecast = forecast else {
            return 0
        }
        
        return forecast.weather.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath
        indexPath: NSIndexPath) -> UITableViewCell {
        
        let identifier = "WeatherCell"
        
        let deque = tableView.dequeueReusableCellWithIdentifier(identifier)
        let cell = deque as! WeatherCell
        cell.weather = forecast?.weather[indexPath.row]
        
        return cell
    }
}