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
            
            it("should not have a forecast") {
                expect(controller.forecast).to(beNil())
            }
            
            describe("loading the view") {
                
                beforeEach {
                    controller.viewDidLoad()
                }
                
                describe("the refresh control") {
                    
                    var refreshControl: UIRefreshControl?
                    
                    beforeEach {
                        refreshControl = controller.refreshControl
                    }
                    
                    it("should exist") {
                        expect(refreshControl).toNot(beNil())
                    }
                    
                    it("should have the correct tint") {
                        let expected = Defaults.Color.Secondary.base
                        expect(refreshControl?.tintColor).to(equal(expected))
                    }
                    
                    it("should have the correct target") {
                        let targets = refreshControl?.allTargets()
                        expect(targets).to(contain(controller))
                    }
                    
                    it("should have the correct action for target") {
                        let actionsForTarget = refreshControl!.actionsForTarget
                        let actions = actionsForTarget(controller,
                                                       forControlEvent: .TouchUpInside)
                        expect(actions).to(contain("refresh"))
                    }
                }
            }
            
            describe("refreshing") {
                
                context("without a delegate") {
                    beforeEach {
                        controller.delegate = nil
                        controller.refresh()
                    }
                    
                    describe("the refresh control") {
                        it("should not be refreshing") {
                            let refreshControl = controller.refreshControl
                            expect(refreshControl?.refreshing).toNot(beTrue())
                        }
                    }
                }
                
                context("with a delegate") {
                    class Delegate: WeatherTableViewControllerDelegate {
                        var refreshCalled = false
                        private func controllerWantsToRefresh(controller: WeatherTableViewController) {
                            refreshCalled = true
                        }
                    }
                    
                    var delegate: Delegate!
                    beforeEach {
                        delegate = Delegate()
                        controller.delegate = delegate
                        controller.refresh()
                    }
                    
                    it("should animate the refresh control") {
                        let refreshControl = controller.refreshControl
                        expect(refreshControl?.refreshing).to(beTrue())
                    }
                    
                    it("should call the delegate") {
                        expect(delegate.refreshCalled).to(beTrue())
                    }
                }
            }
            
            describe("the table view details") {
                var tableView: UITableView!
                
                beforeEach {
                    tableView = controller.tableView
                }
                
                it("should not have a footer view") {
                    let footer = controller.tableView(tableView,
                                                      viewForFooterInSection: 0)
                    expect(footer).to(beNil())
                }
                
                it("should return a height of 1 for footer") {
                    let h = controller.tableView(tableView,
                                                 heightForFooterInSection: 0)
                    expect(h).to(equal(1))
                }
                
                it("should return a height of 140 for header") {
                    let h = controller.tableView(tableView,
                                                 heightForHeaderInSection: 0)
                    expect(h).to(equal(140))
                }
                
                context("with a forecast") {
                
                    let forecast = Forecast(data: ResponseData.Forecast.London.jsonData)
                    
                    beforeEach {
                        controller.forecast = forecast
                    }

                    
                    it("should have one section") {
                        let num = controller.numberOfSectionsInTableView(tableView)
                        expect(num).to(equal(1))
                    }
                    
                    it("should have as many rows in section 0 as weathers") {
                        let num = controller.tableView(tableView,
                                                       numberOfRowsInSection: 0)
                        expect(num).to(equal(forecast?.weather.count))
                    }
                    
                    it("should have 0 rows in section 1") {
                        let num = controller.tableView(tableView,
                                                       numberOfRowsInSection: 1)
                        expect(num).to(equal(0))
                    }
                    
                    describe("loading a cell") {
                        var cell: WeatherCell?
                        
                        beforeEach {
                            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                            cell = controller.tableView(tableView,
                                cellForRowAtIndexPath: indexPath) as? WeatherCell
                        }
                        
                        it("should exist") {
                            expect(cell).toNot(beNil())
                        }
                        
                        it("should have a weather object") {
                            expect(cell?.weather).toNot(beNil())
                        }
                    }
                    
                    describe("selecting a row") {
                        
                        beforeEach {
                            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                            tableView.selectRowAtIndexPath(indexPath,
                                animated: false, scrollPosition: .Bottom)
                            controller.tableView(tableView,
                                didSelectRowAtIndexPath: indexPath)
                        }
                        
                        it("should not remain selected") {
                            expect(tableView.indexPathForSelectedRow)
                                .toEventually(beNil())
                        }
                        
                    }
                    
                    
                    describe("the header") {
                        var header: UIView?
                        
                        beforeEach {
                            header = controller.tableView(tableView,
                                viewForHeaderInSection: 0)
                        }
                        
                        it("should not be nil") {
                            expect(header).toNot(beNil())
                        }
                        
                        it("should be of type WeatherHeaderView") {
                            expect(header is WeatherHeaderView).to(beTrue())
                        }
                    }
                }
            
                context("without a forecast") {
                    
                    beforeEach {
                        controller.forecast = nil
                    }
                    
                    it("should have no sections") {
                        expect(controller.numberOfSectionsInTableView(tableView))
                            .to(equal(0))
                    }
                    
                    it("should have no rows") {
                        expect(controller.tableView(tableView, numberOfRowsInSection: 0))
                            .to(equal(0))
                    }
                    
                    
                    describe("the header") {
                        var header: UIView?
                        
                        beforeEach {
                            header = controller.tableView(tableView,
                                viewForHeaderInSection: 0)
                        }
                        
                        it("should be nil") {
                            expect(header).to(beNil())
                        }
                    }
                }
            }
            
            describe("with a mock tableView") {
                
                class MockTableView: UITableView {
                    
                    var reloadDataCalled = false
                    
                    private override func reloadData() {
                        reloadDataCalled = true
                    }
                }
                
                var mockTableView: MockTableView!
                
                beforeEach {
                    mockTableView = MockTableView()
                    controller.viewDidLoad()
                    controller.tableView = mockTableView
                }
                
                describe("setting the forecast") {
                    
                    beforeEach {
                        controller.refreshControl?.beginRefreshing()
                        let forecast = Forecast(data: ResponseData.Forecast.London.jsonData)
                        controller.forecast = forecast
                    }

                    describe("the refreshing control") {
                        it("should stop refreshing") {
                            expect(controller.refreshControl?.refreshing).to(beFalse())
                        }
                    }
                    
                    it("should reload the table view") {
                        expect(mockTableView.reloadDataCalled).to(beTrue())
                    }
                }
            }
        }
    }
}