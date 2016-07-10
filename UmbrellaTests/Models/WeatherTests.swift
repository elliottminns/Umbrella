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
        
        describe("an array of weather objects") {
            
            var weather: [Weather] = []
            
            context("an empty array") {
                
                describe("the average temperature") {
                    
                    var average: Temperature?
                    
                    beforeEach {
                        average = weather.averageTemperature(inUnit: .Celsius)
                    }
                    
                    it("should be nil") {
                        expect(average).to(beNil())
                    }
                }
                
                describe("most occuring condition") {
                    var condition: WeatherCondition?
                    
                    beforeEach {
                        condition = weather.mostOccuringCondition()
                    }
                    
                    it("should be nil") {
                        expect(condition).to(beNil())
                    }
                }
                
                describe("finding for 3 hours infront") {
                    
                    var hours: [Weather] = []
                    beforeEach {
                        hours = weather.elements(forHours: 3)
                    }
                    
                    it("should be empty") {
                        expect(hours).to(beEmpty())
                    }
                }
            }
            
            context("from forecast data") {
                
                beforeEach {
                    let data = ResponseData.Forecast.London.jsonData
                    let forecast = Forecast(data: data)!
                    weather = forecast.weather
                }
                
                describe("finding for 3 hours infront") {
                    
                    var hours: [Weather] = []
                    
                    func hoursWithStartingTime(now: NSDate) -> [Weather] {
                        
                        var weather: [Weather] = []
                        
                        for i in 0 ..< 3 {
                            let threeHour: NSTimeInterval = 3600 * 3
                            let start = now.dateByAddingTimeInterval(threeHour * NSTimeInterval(i))
                            let end = start.dateByAddingTimeInterval(threeHour)
                            let w = Weather(start: start, end: end,
                                            condition: .Clouds, description: "some clouds",
                                            temperature: Temperature(value: 15, type: .Celsius),
                                            icon: .CloudyNight)
                            
                            
                            weather.append(w)
                        }
                        
                        hours = weather.elements(forHours: 3)
                        return hours
                    }
                    
                    context("with no matching weather") {
                        beforeEach {
                            hours = hoursWithStartingTime(NSDate().dateByAddingTimeInterval(-172000))
                        }
                        
                        it("should be empty") {
                            expect(hours).to(beEmpty())
                        }
                    }
                    
                    context("with one matching weather") {
                        beforeEach {
                            hours = hoursWithStartingTime(NSDate())
                        }
                        
                        it("should not be empty") {
                            expect(hours).toNot(beEmpty())
                        }
                        
                        it("should have a count of 1") {
                            expect(hours.count).to(equal(1))
                        }
                    }
                }
                
                describe("the average temperature") {
                    var average: Temperature?
                    
                    beforeEach {
                        average = weather.averageTemperature(inUnit: .Celsius)
                    }
                    
                    it("should not be nil") {
                        expect(average).toNot(beNil())
                    }
                    
                    it("should be correct") {
                        expect(average!.value).to(beCloseTo(16.18))
                    }
                }
                
                describe("the most occuring condition") {
                    var condition: WeatherCondition?
                    
                    beforeEach {
                        condition = weather.mostOccuringCondition()
                    }
                    
                    it("should not be nil") {
                        expect(condition).toNot(beNil())
                    }
                    
                    it("should be clouds") {
                        expect(condition).to(equal(WeatherCondition.Clouds))
                    }
                }
                
            }
            
        }
        
        describe("creating with json") {
            
            var json: [String: AnyObject] = [:]
            
            context("London forecast") {
                
                let data = ResponseData.Weather.Rain
                
                beforeEach {
                    json = data.jsonData
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
                    
                    it("should have an icon") {
                        expect(weather?.icon).toNot(beNil())
                    }
                    
                    it("should have the correct icon") {
                        expect(weather?.icon).to(equal(WeatherIcon.Rain))
                    }
                }
            }
        }
    }
}