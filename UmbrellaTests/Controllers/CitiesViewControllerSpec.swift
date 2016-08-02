//
//  CitiesViewControllerSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class MockCitiesDelegate: CitiesViewControllerDelegate {
    
    var selectedCity: City?
    
    func viewController(controller: CitiesViewController, didSelectCity city: City) {
        selectedCity = city
    }
}

class CitiesViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        let cityCount = 5
        
        describe("the controller's cities") {
            
            let controller = CitiesViewController()
            
            it("should have the correct number") {
                expect(controller.cities.count) == cityCount
            }
            
            it("should be ordered from A-Z") {
                let _ = controller.cities.reduce("", combine: { previousName, current in
                    let result = current.name.compare(previousName)
                    expect(result).toNot(equal(NSComparisonResult.OrderedAscending))
                    return current.name
                })
            }
            
        }
        
        describe("creating via the storyboard") {
            
            var controller: CitiesViewController!
            
            beforeEach {
                
                let storyboard = UIStoryboard(name: "Main",
                    bundle: NSBundle(forClass: CitiesViewController.self))
                
                controller = storyboard
                    .instantiateViewControllerWithIdentifier("CitiesViewController") as! CitiesViewController
                
                UIApplication.sharedApplication().keyWindow!.rootViewController = controller
            }
            
            describe("the close button") {
                
                var button: UIBarButtonItem!
                
                beforeEach {
                    button = controller.closeButton
                }
                
                it("should not be nil") {
                    expect(button) != nil
                }
                
                it("should have the correct target") {
                    expect(button.target as? CitiesViewController) == controller
                }
                
                it("should point to the close method") {
                    expect(button.action) == #selector(CitiesViewController.close)
                }
            }
            
            describe("the close method") {
                
                class MockPresentingController: UIViewController {
                    var dismissedCalled = false
                    var dismissAnimated = false
                    
                    private override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
                        dismissedCalled = true
                        dismissAnimated = flag
                    }
                }
                
                context("with a mock presenting controller") {
                    
                    var mock: MockPresentingController!
                    
                    beforeEach {
                        
                        waitUntil { done in
                            mock = MockPresentingController()
                            UIApplication.sharedApplication().keyWindow!
                                .rootViewController = mock
                            mock.presentViewController(controller,
                                animated: false,
                                completion: done)
                        }
                        
                    }
                    
                    it("should call dismiss") {
                        controller.close()
                        expect(mock.dismissedCalled) == true
                    }
                    
                    it("should call it with animation") {
                        controller.close()
                        expect(mock.dismissAnimated) == true
                    }
                }
            }
            
            it("should not be nil")  {
                expect(controller).toNot(beNil())
            }
            
            describe("the table view data") {
            
                var tableView: UITableView!
                
                beforeEach {
                    tableView = controller.tableView
                }
                
                it("should return 1 section") {
                    expect(controller.numberOfSectionsInTableView(tableView)) == 1
                }
                
                it("should return the correct number of rows for the first section") {
                    let rowCount = controller.tableView(tableView, numberOfRowsInSection: 0)
                    expect(rowCount) == cityCount
                }
                
                it("should produce a cell for correct identifier") {
                    let identifier = "CityCell"
                    let cell = tableView.dequeueReusableCellWithIdentifier(identifier)
                    
                    expect(cell).toNot(beNil())
                }
                
                describe("the cells") {
                    
                    for i in 0 ..< cityCount {
                        
                        describe("the cell at \(i)") {
                            
                            var cell: UITableViewCell!
                            var city: City!
                            var index: NSIndexPath!
                            
                            beforeEach {
                                index = NSIndexPath(forRow: i, inSection: 0)
                                cell = controller.tableView(tableView,
                                    cellForRowAtIndexPath: index)
                                city = controller.cities[i]
                            }
                            
                            it("should have the correct text") {
                                
                                expect(cell.textLabel?.text) == city.name
                            }
                            
                            describe("the cell selection callback") {
                                
                                let selectCell = {
                                    controller.tableView(tableView,
                                                         didSelectRowAtIndexPath: index)
                                }
                                
                                context("using a mock delegate") {
                                    
                                    var mock: MockCitiesDelegate!
                                    
                                    beforeEach {
                                        mock = MockCitiesDelegate()
                                        controller.delegate = mock
                                        selectCell()
                                    }
                                    
                                    afterEach {
                                        controller.delegate = nil
                                    }
                                    
                                    it("should call the delegate with the correct city") {
                                        expect(mock.selectedCity?.name) == city.name
                                    }
                                }
                            }
                        }
                     }
                }
            }
        }
    }
}