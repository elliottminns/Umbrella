//
//  ForecastRequestSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella
import CoreLocation

class ForecastRequestSpec: QuickSpec {
    
    override func spec() {
        
        describe("a standard forecast request") {
            let request = ForecastRequest(latitude: 51.3, longitude: -0.13)
            
            it("should have the correct baseUrl") {
                let expected = NSURL(string: "http://api.openweathermap.org")
                expect(request.baseUrl).to(equal(expected))
            }
            
            it("should have the correct path") {
                expect(request.path).to(equal("/data/2.5/forecast"))
            }
            
            it("should have the correct method") {
                expect(request.method).to(equal(RequestMethod.GET))
            }
            
            describe("the requests parameters") {
                it("should have an APPID") {
                    expect(request.parameters.keys).to(contain("APPID"))
                }
                
                it("should have a lon") {
                    expect(request.parameters.keys).to(contain("lon"))
                }
                
                it("should have a lat") {
                    expect(request.parameters.keys).to(contain("lat"))
                }
                
                it("should have a count") {
                    expect(request.parameters.keys).to(contain("cnt"))
                }
                
                it("should have a count of 6") {
                    expect(request.parameters["cnt"] as? Int).to(equal(6))
                }
                
                it("should have the correct latitude") {
                    let lat = request.parameters["lat"] as? Double
                    expect(lat).to(equal(51.3))
                }
                
                it("should have the correct longitude") {
                    let lon = request.parameters["lon"] as? Double
                    expect(lon).to(equal(-0.13))
                }
            }
            
            describe("loading with a core location") {
                let location = CLLocation(latitude: 51.8, longitude: -0.11)
                let clrequest = ForecastRequest(location: location)
                
                describe("the location parameters") {
                    
                    it("should have the correct latitude") {
                        let lat = clrequest.parameters["lat"] as? Double
                        expect(lat).to(equal(51.8))
                    }
                    
                    it("should have the correct longitude") {
                        let lon = clrequest.parameters["lon"] as? Double
                        expect(lon).to(equal(-0.11))
                    }
                    
                }
            }
        }
    }
    
}