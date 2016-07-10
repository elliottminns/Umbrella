//
//  WeatherIconSpecs.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherIconSpec: QuickSpec {
    override func spec() {
        describe("creating an icon with a string") { 
            
            let tests: [(string: String, expected: WeatherIcon?)] = [
                ("01d", WeatherIcon.ClearSkyDay),
                ("01n", WeatherIcon.ClearSkyNight),
                ("02d", WeatherIcon.CloudyDay),
                ("02n", WeatherIcon.CloudyNight),
                ("03d", WeatherIcon.Overcast),
                ("03n", WeatherIcon.Overcast),
                ("04d", WeatherIcon.Overcast),
                ("04n", WeatherIcon.Overcast),
                ("09d", WeatherIcon.Rain),
                ("09n", WeatherIcon.Rain),
                ("10d", WeatherIcon.Rain),
                ("10n", WeatherIcon.Rain),
                ("11d", WeatherIcon.Thunderstorm),
                ("11d", WeatherIcon.Thunderstorm),
                ("13d", WeatherIcon.Snow),
                ("13n", WeatherIcon.Snow),
                ("50d", WeatherIcon.Mist),
                ("50n", WeatherIcon.Mist)
            ]
            
            tests.forEach { test in
                context("with the icon string " + test.string) {
                    
                    it("should produce the expected result") {
                        let icon = WeatherIcon(string: test.string)
                        expect(icon).to(equal(test.expected))
                    }
                }
            }
        }
    }
}
