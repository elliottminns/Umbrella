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

class WeatherViewControllerSpec: QuickSpec {
    
    override func spec() {
        
        var controller: WeatherViewController!
        
        beforeEach {
            controller = WeatherViewController()
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