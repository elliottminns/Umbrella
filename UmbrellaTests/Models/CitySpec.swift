//
//  CitySpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 02/08/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Umbrella

class CitySpec: QuickSpec {
    override func spec() {
        
        describe("creating the city") {
            
            let name = "London"
            let latitude: CLLocationDegrees = 51.3
            let longitude: CLLocationDegrees = -0.13
            var city: City!
            
            beforeEach {
                city = City(name: name, latitude: latitude, longitude: longitude)
            }
            
            it("should have the correct name") {
                expect(city.name) == "London"
            }
            
            
            describe("the location") {
                var location: CLLocation!
                
                beforeEach {
                    location = city.location
                }
                
                it("should have the correct latitude") {
                    expect(location.coordinate.latitude) == latitude
                }
                
                it("should have the correct longitude") {
                    expect(location.coordinate.longitude) == longitude
                }
            }
        }
    }
}