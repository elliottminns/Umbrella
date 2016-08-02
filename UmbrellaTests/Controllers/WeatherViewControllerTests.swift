//
//  WeatherViewControllerTests.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Umbrella

class MockWeatherController: WeatherViewController {
    
    var getForecastCalled = false
    var showAlertCalled = false
    var alertTitle: String?
    var alertMessage: String?
    var alertActions: [UIAlertAction] = []
    var displayRetryCalled = false
    
    override func getForecast<T : Service where T.Data == Forecast>(fromService service: T) {
        getForecastCalled = true
        super.getForecast(fromService: service)
    }
    
    override func showAlert(title title: String, message: String, actions: [UIAlertAction]) {
        showAlertCalled = true
        alertTitle = title
        alertMessage = message
        alertActions = actions
    }
    
    override func displayRetry() {
        displayRetryCalled = true
    }
}

class WeatherViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        context("using a mock controller") {
            var controller: MockWeatherController!
            
            beforeEach {
                Requester.defaultClient = MockRequestClient(data: nil, response: nil, error: nil)
                controller = MockWeatherController()
            }
            
            describe("clicking the retry button") {
                beforeEach {
                    controller.retryButtonPressed(UIButton())
                }
                
                it("should call get forecast") {
                    expect(controller.getForecastCalled).to(beTrue())
                }
            }
            
            describe("wants to refresh method") {
                beforeEach {
                    let cnt = WeatherTableViewController()
                    controller.controllerWantsToRefresh(cnt)
                }
                
                it("should call get forecast") {
                    expect(controller.getForecastCalled).to(beTrue())
                }
            }
            
            describe("error handling") {
                
                struct Test {
                    let name: String
                    let error: ErrorType
                    let showsAlert: Bool
                    let message: String?
                    let title: String?
                    let actions: Set<String>
                }
                
                let tests: [Test] =
                    [Test(name: "location denied",
                        error: LocationServiceError.LocationDenied,
                        showsAlert: true,
                        message: "Please allow your location for us to proivde you weather forecasts",
                        title: "Location Denied",
                        actions: ["Dismiss", "Settings"]),
                     
                     Test(name: "location failed",
                        error: LocationServiceError.LocationFailed,
                        showsAlert: true,
                        message: "We could not discover your location, please try again",
                        title: "Location Failed",
                        actions: ["Dismiss"]),
                     
                     Test(name: "location restricted",
                        error: LocationServiceError.LocationRestricted,
                        showsAlert: true,
                        message: "Please check your settings to unrestrict location access",
                        title: "Location Restricted",
                        actions: ["Dismiss", "Settings"]),
                     
                     Test(name: "request failed",
                        error: RequestError(message: "Something"),
                        showsAlert: true,
                        message: "Please check your internet settings and try again",
                        title: "Could not load weather data",
                        actions: ["Dismiss"]),
                        
                     Test(name: "NSError",
                        error: NSError(domain: "test", code: 101, userInfo: nil),
                        showsAlert: false,
                        message: nil,
                        title: nil,
                        actions: [])
                     ]
                
                tests.forEach { test in
                    
                    describe("with an error of " + test.name) {
                    
                        beforeEach {
                            controller.handle(error: test.error)
                        }
                        
                        it("should call display retry") {
                            expect(controller.displayRetryCalled)
                                .to(beTrue())
                        }
                        
                        describe("the alert") {
                            
                            it("should call show alert") {
                                expect(controller.showAlertCalled)
                                    .to(equal(test.showsAlert))
                            }
                            
                            it("should show the correct message") {
                                if (test.message == nil) {
                                    expect(controller.alertMessage).to(beNil())
                                } else {
                                    expect(controller.alertMessage)
                                        .to(equal(test.message))
                                }
                            }
                            
                            it("should show the correct title") {
                                if (test.title == nil) {
                                    expect(controller.alertTitle).to(beNil())
                                } else {
                                    expect(controller.alertTitle)
                                        .to(equal(test.title))
                                }
                            }
                            
                            describe("the alert actions") {
                                it("should have the correct amount") {
                                    expect(controller.alertActions.count)
                                        .to(equal(test.actions.count))
                                }
                                
                                it("should have the correct buttons") {
                                    for action in controller.alertActions {
                                        expect(test.actions)
                                            .to(contain(action.title))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        context("the storyboard controller") {
            
            var controller: WeatherViewController!
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main", bundle: NSBundle(forClass: WeatherViewController.self))
                controller = storyboard.instantiateInitialViewController() as! WeatherViewController
                UIApplication.sharedApplication().keyWindow!.rootViewController = controller
            }
            
            describe("Setting the forecast") {
                let forecast = Forecast(data: ResponseData.Forecast.London.jsonData)
                
                it("should set the table controllers forecast") {
                    expect(controller.tableViewController?.forecast).to(beNil())
                    controller.forecast = forecast
                    expect(controller.tableViewController?.forecast).toNot(beNil())
                }
            }
            
            describe("The IB elements") {
                
                describe("the table view controller") {
                    
                    it("should exist") {
                        expect(controller.tableViewController).toNot(beNil())
                    }
                    
                    it("should have a delegate") {
                        expect(controller.tableViewController?.delegate).toNot(beNil())
                    }
                }
                
                it("should have a loading label") {
                    expect(controller.loadingLabel).toNot(beNil())
                }
                
                it("should have a loading indicator") {
                    expect(controller.loadingIndicator).toNot(beNil())
                }
                
                describe("The cities button") {
                    var button: UIButton?
                    
                    beforeEach {
                        button = controller.citiesButton
                    }
                    
                    it("should not be nil") {
                        expect(button).toNot(beNil())
                    }
                    
                    it("should have the correct title") {
                        let title = button?.titleForState(.Normal)
                        expect(title) == "Cities"
                    }
                }
                
                describe("the retry button") {
                    it("should have the correct target") {
                        let targets = controller.retryButton?.allTargets()
                        expect(targets).to(contain(controller))
                    }
                    
                    it("should have the correct action") {
                        let actions = controller.retryButton?
                            .actionsForTarget(controller,
                                              forControlEvent: .TouchUpInside)
                        let expected = "retryButtonPressed:"
                        expect(actions).to(contain(expected))
                    }
                    it("should exist") {
                        expect(controller.retryButton).toNot(beNil())
                    }
                }
            }
            
            
            describe("loading the weather controller") {
                beforeEach {
                    Requester.defaultClient = MockRequestClient(forecastData: nil,
                        weatherData: nil)
                    controller.viewDidLoad()
                }
                
                it("should set the correct background color") {
                    expect(controller.view.backgroundColor)
                        .to(equal(Defaults.Color.Primary.base))
                }
                
                describe("the loading label") {
                    it("should have the correct font") {
                        expect(controller.loadingLabel?.font)
                            .to(equal(Defaults.Fonts.Normal.font))
                    }
                    
                    it("should have the correct text color") {
                        expect(controller.loadingLabel?.textColor)
                            .to(equal(Defaults.Color.Secondary.base))
                    }
                }
                
                describe("the retry button") {
                    it("should have the correct background color") {
                        expect(controller.retryButton?.backgroundColor)
                            .to(equal(Defaults.Color.Secondary.base))
                    }
                    
                    it("should be hidden") {
                        expect(controller.retryButton?.hidden).to(beTrue())
                    }
                    
                    it("should have the correct corner radius") {
                        expect(controller.retryButton?.layer.cornerRadius)
                            .to(equal(5))
                    }
                }
            }
            
            describe("displaying the loading UI") {
                
                context("with a visible table view controller") {
                    beforeEach {
                        controller.tableViewContainer?.hidden = false
                        controller.loadingLabel?.hidden = true
                        controller.loadingLabel?.text = ""
                        controller.loadingIndicator?.stopAnimating()
                        controller.retryButton?.hidden = true
                        controller.displayLoading()
                    }
                    
                    it("should show the menu activity indicator") {
                        let application = UIApplication.sharedApplication()
                        expect(application.networkActivityIndicatorVisible)
                            .to(beTrue())
                    }
                    
                    it("should not show the loading label") {
                        expect(controller.loadingLabel?.hidden).to(beTrue())
                    }
                    
                    it("should not have the loading weather text") {
                        expect(controller.loadingLabel?.text)
                            .toNot(equal("Loading Weather"))
                    }
                    
                    it("should not show the loading indicator") {
                        expect(controller.loadingIndicator?.hidden).toNot(beFalse())
                    }
                    
                    it("should not be animating the loading indicator") {
                        expect(controller.loadingIndicator?.isAnimating())
                            .toNot(beTrue())
                    }
                    
                    it("should not show the retry button") {
                        expect(controller.retryButton?.hidden).to(beTrue())
                    }
                    
                }
                
                context("with a hidden table view controller") {
                    beforeEach {
                        controller.tableViewContainer?.hidden = true
                        controller.loadingLabel?.hidden = true
                        controller.loadingLabel?.text = ""
                        controller.loadingIndicator?.stopAnimating()
                        controller.retryButton?.hidden = true
                        controller.displayLoading()
                    }
                    
                    it("should show the menu activity indicator") {
                        let application = UIApplication.sharedApplication()
                        expect(application.networkActivityIndicatorVisible)
                            .to(beTrue())
                    }
                    
                    it("should show the loading label") {
                        expect(controller.loadingLabel?.hidden).to(beFalse())
                    }
                    
                    it("should have the correct text") {
                        expect(controller.loadingLabel?.text)
                            .to(equal("Loading Weather"))
                    }
                    
                    it("should show the loading indicator") {
                        expect(controller.loadingIndicator?.hidden).to(beFalse())
                    }
                    
                    it("should be animating the loading indicator") {
                        expect(controller.loadingIndicator?.isAnimating())
                            .to(beTrue())
                    }
                    
                    it("should hide the retry button") {
                        expect(controller.retryButton?.hidden).to(beTrue())
                    }
                }
            }
            
            describe("showing the alert view") {
                let title = "Alert Title"
                let message = "Alert Message"
                var actions: [UIAlertAction] = []
                
                var alertController: UIAlertController?
                
                beforeEach {
                    let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                    let dismiss = UIAlertAction(title: "Dismiss", style: .Default, handler: nil)
                    actions.append(cancel)
                    actions.append(dismiss)
                    controller.showAlert(title: title, message: message, actions: actions)
                    alertController = controller.presentedViewController as? UIAlertController
                }
                
                it("should display the alert") {
                    expect(alertController).toNot(beNil())
                }
                
                it("should have the correct title") {
                    expect(alertController?.title).to(equal(title))
                }
                
                it("should have the correct message") {
                    expect(alertController?.message).to(equal(message))
                }
                
                it("should be of type alert") {
                    expect(alertController?.preferredStyle)
                        .to(equal(UIAlertControllerStyle.Alert))
                }
                
                it("should have the correct actions") {
                    for action in actions {
                        expect(alertController?.actions).to(contain(action))
                    }
                }
            }
            
            describe("hiding the loading views") {
                beforeEach {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                    controller.loadingIndicator?.startAnimating()
                    controller.loadingLabel?.hidden = false
                    controller.loadingIndicator?.alpha = 0
                    controller.loadingLabel?.alpha = 0
                    controller.hideLoadingViews()
                }
                
                it("should hide the network activity indicator") {
                    let application = UIApplication.sharedApplication()
                    expect(application.networkActivityIndicatorVisible).to(beFalse())
                }
                
                it("should stop animating the loading indicator") {
                    expect(controller.loadingIndicator?.isAnimating())
                        .toEventually(beFalse())
                }
                
                it("should hide the loading label") {
                    expect(controller.loadingLabel?.hidden)
                        .toEventually(beTrue())
                }
                
                it("should set the alpha of the indicator to 1.0") {
                    expect(controller.loadingIndicator?.alpha)
                        .toEventually(beCloseTo(1.0))
                }
                
                it("should set the alpha of the label to 1.0") {
                    expect(controller.loadingLabel?.alpha)
                        .toEventually(beCloseTo(1.0))
                }
            }
            
            describe("showing the table view") {
                beforeEach {
                    controller.tableViewContainer?.hidden = true
                    controller.showTableView()
                }
                
                it("should unhide the table view") {
                    expect(controller.tableViewContainer?.hidden).to(beFalse())
                }
            }
            
            describe("displaying the retry UI") {
                
                beforeEach {
                    controller.loadingIndicator?.startAnimating()
                    controller.loadingLabel?.text = ""
                    controller.loadingLabel?.hidden = true
                    controller.retryButton?.hidden = true
                }
                
                context("with the table view hidden") {
                    beforeEach {
                        controller.tableViewContainer?.hidden = true
                        controller.displayRetry()
                    }
                    
                    it("should stop the loading indicator") {
                        expect(controller.loadingIndicator?.isAnimating())
                            .to(beFalse())
                    }
                    
                    it("should set the correct loading label text") {
                        expect(controller.loadingLabel?.text)
                            .to(equal("Could not load weather"))
                    }
                    
                    it("should unhide the loading label") {
                        expect(controller.loadingLabel?.hidden).to(beFalse())
                    }
                    
                    it("should unhide the retry button") {
                        expect(controller.retryButton?.hidden).to(beFalse())
                    }
                }
                
                context("with the table view visible") {
                    beforeEach {
                        controller.tableViewContainer?.hidden = false
                        controller.displayRetry()
                    }
                    
                    it("should stop the loading indicator") {
                        expect(controller.loadingIndicator?.isAnimating())
                            .to(beFalse())
                    }
                    
                    it("should not set the loading label text") {
                        expect(controller.loadingLabel?.text)
                            .toNot(equal("Could not load weather"))
                    }
                    
                    it("should not unhide the loading label") {
                        expect(controller.loadingLabel?.hidden).toNot(beFalse())
                    }
                    
                    it("should not unhide the retry button") {
                        expect(controller.retryButton?.hidden).toNot(beFalse())
                    }
                }
            }
            
            describe("the status bar style") {
                it("should be light") {
                    expect(controller.preferredStatusBarStyle())
                        .to(equal(UIStatusBarStyle.LightContent))
                }
            }
            
            describe("getting weather") {
                
                var mockService: ForecastServiceMock!
                
                context("using a default mock weather service") {
                    
                    beforeEach {
                        mockService = ForecastServiceMock()
                        controller.getForecast(fromService: mockService)
                    }
                    
                    describe("the controllers weather object") {
                        
                        it("should exist") {
                            expect(controller.forecast).toNot(beNil())
                        }
                    }
                    
                    describe("the service") {
                        
                        it("should be called") {
                            expect(mockService.getWeatherCalled).to(beTrue())
                        }
                    }
                }
                
                context("using an errroneous mock service") {
                    struct ServiceError: ErrorType {
                        let message: String
                    }
                    
                    let error = ServiceError(message: "Mock Error Message")
                    
                    let result = Result<Forecast>.Failure(error)
                    
                    beforeEach {
                        mockService = ForecastServiceMock(result: result)
                        controller.getForecast(fromService: mockService)
                    }
                    
                    describe("the controllers weather object") {
                        it("should not exist") {
                            expect(controller.forecast).to(beNil())
                        }
                    }
                }
            }
        }
    }
}