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
            
            it("should convert to celsius correctly") {
                let cel = temp.converted(to: .Celsius)
                expect(cel.value).to(equal(-271.15))
            }
            
            it("should convert to farenheit correctly") {
                let faren = temp.converted(to: .Farenheit)
                expect(faren.value).to(equal(-456.07))
            }
            
            describe("comparing to its equivilents") {
                
                it("should equal with kelvin") {
                    let kelvin = Temperature(value: 2, type: .Kelvin)
                    expect(temp).to(equal(kelvin))
                }
                
                it("should equal with farenheit") {
                    let faren = Temperature(value: -456.07, type: .Farenheit)
                    expect(temp).to(equal(faren))
                }
                
                it("should equal with celsius") {
                    let cel = Temperature(value: -271.15, type: .Celsius)
                    expect(temp).to(equal(cel))
                }
            }
        }
        
        describe("setting a temperature of 88º farenheit") {
            beforeEach {
                temp = Temperature(value: 88, type: .Farenheit)
            }
            
            it("should convert to kelvin correctly") {
                let kel = temp.converted(to: .Kelvin)
                expect(kel.value).to(beCloseTo(304.2611))
            }
            
            it("should convert to celsius correctly") {
                let celsius = temp.converted(to: .Celsius)
                expect(celsius.value).to(beCloseTo(31.1111))
            }
            
            it("should convert to farenheit correctly") {
                let faren = temp.converted(to: .Farenheit)
                expect(faren.value).to(equal(88))
            }
            
            describe("comparing to its equivilents") {
                
                it("should equal with kelvin") {
                    let kelvin = Temperature(value: 304.26, type: .Kelvin)
                    expect(temp).to(equal(kelvin))
                }
                
                it("should equal with farenheit") {
                    let faren = Temperature(value: 88, type: .Farenheit)
                    expect(temp).to(equal(faren))
                }
                
                it("should equal with celsius") {
                    let cel = Temperature(value: 31.11, type: .Celsius)
                    expect(temp).to(equal(cel))
                }
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
                expect(faren.value).to(beCloseTo(64.4))
            }
            
            describe("comparing to its equivilents") {
                
                it("should equal with kelvin") {
                    let kelvin = Temperature(value: 291.15, type: .Kelvin)
                    expect(temp).to(equal(kelvin))
                }
                
                it("should equal with farenheit") {
                    let faren = Temperature(value: 64.4, type: .Farenheit)
                    expect(temp).to(equal(faren))
                }
                
                it("should equal with celsius") {
                    let cel = Temperature(value: 18, type: .Celsius)
                    expect(temp).to(equal(cel))
                }
            }
        }
    }
    
}
