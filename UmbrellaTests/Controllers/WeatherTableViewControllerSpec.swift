//
//  WeatherTableViewControllerSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherTableViewControllerSpec: QuickSpec {
    override func spec() {
        
        describe("the storyboard controller") {
            
            var controller: WeatherTableViewController!
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: WeatherTableViewController.self))
                
                let identifier = "WeatherTableViewController"
                
                controller = storyboard
                    .instantiateViewControllerWithIdentifier(identifier) as!
                    WeatherTableViewController
            }
            
            context("without a forecast") {
                var tableView: UITableView!
                beforeEach {
                    tableView = controller.tableView
                    controller.forecast = nil
                }
                
                describe("the table view") {
                    it("should have no sections") {
                        expect(controller.numberOfSectionsInTableView(tableView))
                            .to(equal(0))
                    }
                    
                    it("should have no rows") {
                        expect(controller.tableView(tableView, numberOfRowsInSection: 0))
                            .to(equal(0))
                    }
                }
            }
        }
    }
}