//
//  CityForecastServiceSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Umbrella

class CityForecastSpec: QuickSpec {
    override func spec() {
        describe("creating the service") {
            
            var service: CityForecastService!
            
            context("with a city") {
                
                let city = City(name: "Cape Town", latitude: 20, longitude: 30)
                
                beforeEach {
                    service = CityForecastService(city: city)
                }
                
                
                describe("the services city") {
                    
                    var city: City!
                    
                    beforeEach {
                        city = service.city
                    }
                    
                    it("should have the correct name") {
                        expect(city.name) == "Cape Town"
                    }
                    
                    describe("the location") {
                        
                        var location: CLLocation!
                        
                        beforeEach {
                            location = city.location
                        }
                        
                        it("should have the correct latitude") {
                            expect(location.coordinate.latitude) == 20
                        }
                        
                        it("should have the correct longitude") {
                            expect(location.coordinate.longitude) == 30
                        }
                    }
                }
                
                describe("using a mock client") {
                    var client: MockRequestClient!
                    
                    beforeEach {
                        client = MockRequestClient(forecastData: ResponseData.Forecast.London.data,
                            weatherData: ResponseData.Weather.Rain.data)
                        Requester.defaultClient = client
                    }
                    
                    describe("calling the service") {
                        
                        var result: Result<Forecast>?
                        
                        beforeEach {
                            waitUntil { done in
                                service.get { (res) in
                                    result = res
                                    done()
                                }
                            }
                        }
                        
                        describe("the result") {
                            it("should not be nil") {
                                expect(result).toNot(beNil())
                            }
                        }
                        
                        describe("the request") {
                            
                            var request: NSURLRequest?
                            
                            beforeEach {
                                request = client.request
                            }
                            
                            it("should not be nil") {
                                expect(request).toNot(beNil())
                            }
                            
                            describe("the request params") {
                                
                                var query: String?
                                
                                beforeEach {
                                    query = request?.URL?.query
                                }
                                
                                it("should be correct") {
                                    let comps = query?.componentsSeparatedByString("&")
                                    
                                    expect(comps).to(contain("lat=20"))
                                    expect(comps).to(contain("lon=30"))
                                }
                                
                            }
                        }
                    }
                }
            }
        }
    }
}