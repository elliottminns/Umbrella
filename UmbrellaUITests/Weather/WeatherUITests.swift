//
//  WeatherUITests.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import XCTest

class WeatherNoInternetUITests: XCTestCase {
    
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("MOCK_NO_INTERNET")
        app.launch()
        
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testInternetFailed() {
        
        let app = XCUIApplication()
        
        let button = app.buttons["Retry"]
        
        app.alerts["Could not load weather data"].buttons["Dismiss"].tap()

        XCTAssertTrue(button.exists)
        
        let hittable = NSPredicate(format: "hittable == true")
        
        expectationForPredicate(hittable, evaluatedWithObject: button, handler: nil)
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
}