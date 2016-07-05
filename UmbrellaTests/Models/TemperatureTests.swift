//
//  TemperatureTests.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class TemperatureSpec: QuickSpec {
    
    override func spec() {
        
        var temp: Temperature!
        
        describe("setting a temperature of 2º kelvin") {
            beforeEach {
                temp = Temperature(value: 2, type: .Kelvin)
            }
            
            it("should convert to kelvin correctly") {
                let kel = temp.converted(to: .Kelvin)
                expect(kel.value).to(equal(2))
            }
            
            fit("should convert to celsius correctly") {
                let cel = temp.converted(to: .Celsius)
                expect(cel.value).to(equal(-271.15))
            }
            
            it("should convert to farenheit correctly") {
                let faren = temp.converted(to: .Farenheit)
                expect(faren.value).to(equal(-456.07))
            }
        }
        
        describe("setting a temperature of 88º farenheit") {
            beforeEach {
                temp = Temperature(value: 88, type: .Farenheit)
            }
            
            it("should convert to kelvin correctly") {
                let kel = temp.converted(to: .Kelvin)
                expect(kel.value).to(equal(304.2611))
            }
            
            it("should convert to celsius correctly") {
                let celsius = temp.converted(to: .Celsius)
                expect(celsius.value).to(equal(31.1111))
            }
            
            it("should convert to farenheit correctly") {
                let faren = temp.converted(to: .Farenheit)
                expect(faren.value).to(equal(88))
            }
        }
        
        describe("setting a temperature of 18º celsius") {
            
            beforeEach {
                temp = Temperature(value: 18, type: .Celsius)
            }
            
            it("should convert to kelvin correctly") {
                let kelvin = temp.converted(to: .Kelvin)
                expect(kelvin.value).to(equal(291.15))
            }
            
            it("should convert to celsius correctly") {
                let cel = temp.converted(to: .Celsius)
                expect(cel.value).to(equal(18))
            }
            
            it("should convert to farenheit correctly") {
                let faren = temp.converted(to: .Farenheit)
                expect(faren.value).to(equal(64.4))
            }
        }
    }
    
}
