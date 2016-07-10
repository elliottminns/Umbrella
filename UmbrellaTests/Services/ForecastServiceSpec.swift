//
//  ForecastServiceSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Umbrella

class ForecastServiceSpec: QuickSpec {
    
    override func spec() {
        
        describe("obtaining with a forcast service") {
            
            let service = ForecastService()
            
            context("with a successful mock location service") {
                var locationService: MockLocationService!
                let location = CLLocation(latitude: 51.03, longitude: -0.13)
                var result: Result<Forecast>!
                
                beforeEach {
                    let res = Result<CLLocation>.Success(location)
                    locationService = MockLocationService(result: res)
                }
                
                context("with a successful mock client") {
                    let forecastData = ResponseData.Forecast.London.data
                    let weatherData = ResponseData.Weather.Rain.data
                    var client: MockRequestClient!
                    
                    beforeEach {
                        client = MockRequestClient(forecastData: forecastData,
                            weatherData: weatherData)
                        Requester.defaultClient = client
                        
                        waitUntil { done in
                            service.get(withLocationService: locationService) { r in
                                result = r
                                done()
                            }
                        }
                    }
                    
                    describe("the request client") {
                        it("should be called") {
                            expect(client.called).to(beTrue())
                        }
                    }
                    
                    describe("the location service") {
                        it("should be called") {
                            expect(locationService.called).to(beTrue())
                        }
                    }
                    
                    describe("the result object") {
                        it("should not be nil") {
                            expect(result).toNot(beNil())
                        }
                        
                        it("should be of type success") {
                            let success: Bool
                            
                            switch result! {
                            case .Failure(_): success = false
                            case .Success(_): success = true
                            }
                            
                            expect(success).to(beTrue())
                            
                        }
                    }
                }
            }
        }
    }
}
