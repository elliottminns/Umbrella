//
//  WeatherTests.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherSpec: QuickSpec {
    
    override func spec() {
        describe("creating with json") {
            var response: String = ""
            var json: [String: AnyObject] = [:]
            
            context("London forecast") {
                
                let data = ResponseData.Weather.Rain
                
                beforeEach {
                    response = data.json
                    let data = response.dataUsingEncoding(NSUTF8StringEncoding)!
                    json = try! NSJSONSerialization.JSONObjectWithData(data,
                        options: []) as! [String : AnyObject]
                }
                
                describe("creating weather with list") {
                    
                    var weather: Weather?
                    
                    beforeEach {
                        weather = Weather(data: json)
                    }
                    
                    it("should not be nil") {
                        expect(weather).toNot(beNil())
                    }
                    
                    it("should have the correct temperature") {
                        let expected = Temperature(value: data.temp, type: .Kelvin)
                        expect(weather?.temperature).to(equal(expected))
                    }
                    
                    it("should have the correct condition") {
                        
                        let correct: Bool
                        switch weather!.condition {
                        case .Rain: correct = true
                        default: correct = false
                        }
                        expect(correct).to(beTrue())
                    }
                    
                    it("should have the correct description") {
                        expect(weather?.description).to(equal(data.description))
                    }
                    
                    it("should have the correct start time") {
                        expect(weather?.start).to(equal(data.start))
                    }
                    
                    it("should have the correct end time") {
                        expect(weather?.end).to(equal(data.end))
                    }
                }
            }
            
        }
    }
}