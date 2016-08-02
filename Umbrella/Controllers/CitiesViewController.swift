//
//  CitiesViewController.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

protocol CitiesViewControllerDelegate: class {
    func viewController(controller: CitiesViewController,
                        didSelectCity city: City)
}

class CitiesViewController: UITableViewController {
    
    @IBOutlet var closeButton: UIBarButtonItem!
    
    let cities: [City] = [City(name: "Berlin", latitude: 0, longitude: 0),
                          City(name: "Dublin", latitude: 0, longitude: 0),
                          City(name: "London", latitude: 0, longitude: 0),
                          City(name: "Portland", latitude: 0, longitude: 0),
                          City(name: "San Jose", latitude: 0, longitude: 0)]
    
    weak var delegate: CitiesViewControllerDelegate?
    
}

// MARK: - Actions
extension CitiesViewController {
    @IBAction func close() {
        presentingViewController?.dismissViewControllerAnimated(true,
                                                                completion: nil)
    }
}

// MARK: - TableViewDataSource
extension CitiesViewController {

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard section == 0 else { return 0 }
        
        return cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "CityCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
        let city = cities[indexPath.row]
        cell?.textLabel?.text = city.name
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row < cities.count else { return }
        let city = cities[indexPath.row]
        delegate?.viewController(self, didSelectCity: city)
    }
}