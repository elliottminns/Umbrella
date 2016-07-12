//
//  NoLocationUITests.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import XCTest

class NoLocationUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launchArguments.append("MOCK_NO_LOCATION")
        app.launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testNoLocation() {
        let app = XCUIApplication()
        
        let button = app.buttons["Retry"]
        
        let alert = app.alerts["Location Failed"]
        XCTAssertTrue(alert.exists)
        alert.buttons["Dismiss"].tap()
        
        XCTAssertTrue(button.exists)
        
        let hittable = NSPredicate(format: "hittable == true")
        
        expectationForPredicate(hittable, evaluatedWithObject: button, handler: nil)
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }

}
