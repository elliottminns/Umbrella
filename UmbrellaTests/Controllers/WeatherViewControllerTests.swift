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
            
            var mockService: WeatherServiceMock!
            
            context("using a default mock weather service") {
                
                beforeEach {
                    mockService = WeatherServiceMock()
                    controller.getWeather(fromService: mockService)
                }
                
                describe("the controllers weather object") {
                    it("should exist") {
                        expect(controller.weather).toNot(beNil())
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
                
                let result = Result<Weather>.Failure(error)
                
                beforeEach {
                    mockService = WeatherServiceMock(result: result)
                    controller.getWeather(fromService: mockService)
                }
                
                describe("the controllers weather object") {
                    it("should not exist") {
                        expect(controller.weather).to(beNil())
                    }
                }
            }
        }
    }
}