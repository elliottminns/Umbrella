//
//  WeatherRequestSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherRequestSpec: QuickSpec {
    
    override func spec() {
        
        describe("a weather request") {
            
            var request: WeatherRequest!
            
            let latitude: Double = 51.5
            let longitude: Double = -0.13
            
            beforeEach {
                request = WeatherRequest(latitude: latitude, longitude: longitude)
            }
            
            it("should have the correct path") {
                expect(request.path).to(equal("/data/2.5/weather"))
            }
            
            it("should have the correct baseURL") {
                let expected = NSURL(string: "http://api.openweathermap.org")
                expect(request.baseUrl).to(equal(expected))
            }
            
            describe("the parameters") {
                it("should have the correct api key") {
                    expect(request.parameters["APPID"] as? String)
                        .to(equal("5af4c3629c715e12a0f1c4048e017a22"))
                }
                
                it("should have the correct longtiude") {
                    expect(request.parameters["lon"] as? Double)
                        .to(equal(longitude))
                }
                
                it("should have the correct latitude") {
                    expect(request.parameters["lat"] as? Double)
                        .to(equal(latitude))
                }
            }
        }
    }
}