//
//  ForecastSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Umbrella

class ForecastSpec: QuickSpec {
    
    override func spec() {
        
        describe("parsing forecast json") {
            
            let forecastData = ResponseData.Forecast.London
            
            var forecast: Forecast?
            
            beforeEach {
                let data = forecastData.jsonData
                forecast = Forecast(data: data)
            }
            
            describe("the forecast") {
                
                it("should not be nil") {
                    expect(forecast).toNot(beNil())
                }
                
                it("should have the correct number of weathers") {
                    expect(forecast?.weather.count).to(equal(forecastData.weatherCount))
                }
                
                it("should have the correcgt place name") { 
                    expect(forecast?.placeName).to(equal("City of Westminster"))
                }
                
                it("should have the correct location") {
                    let coord = forecast?.location.coordinate
                    expect(coord?.latitude).to(beCloseTo(forecastData.latitude))
                    expect(coord?.longitude).to(beCloseTo(forecastData.longitude))
                }
                
                describe("the forecasts weather array") {
                    it("should be sorted by start time") {
                        guard let weather = forecast?.weather else { return }
                        
                        var start: NSDate?
                        
                        weather.forEach {
                            if start == nil {
                                start = $0.start
                            } else {
                                expect($0.start.timeIntervalSince1970).to(beGreaterThan(start?.timeIntervalSince1970))
                                start = $0.start
                            }
                        }
                    }
                }
            }
        }
    }
}