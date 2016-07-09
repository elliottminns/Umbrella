//
//  WeatherConditionSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 08/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherConditionSpec: QuickSpec {
    override func spec() {
        
        describe("creating with a string") {
            
            var condition: WeatherCondition?
            
            let tests: [(value: String, expected: WeatherCondition)] = [
                (value: "Thunderstorm", expected: .Thunderstorm),
                (value: "Drizzle", expected: .Drizzle),
                (value: "Rain", expected: .Rain),
                (value: "Snow", expected: .Snow),
                (value: "Atmosphere", expected: .Atmosphere),
                (value: "Clear", expected: .Clear),
                (value: "Clouds", expected: .Clouds),
                (value: "Extreme", expected: .Extreme),
                (value: "Something", expected: .Additional("Something")),
            ]
            
            tests.forEach { test in
                context("of " + test.value) {
                    
                    beforeEach {
                        condition = WeatherCondition(string: test.value)
                    }
                    
                    it("should not be nil") {
                        expect(condition).toNot(beNil())
                    }
                    
                    it("should be of type Thunderstorm") {
                        expect(condition).to(equal(test.expected))
                    }
                    
                }
            }
        }
    }
}