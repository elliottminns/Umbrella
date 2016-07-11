//
//  WeatherCellSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherCellSpec: QuickSpec {
    override func spec() {
        
        describe("the weather icons") {
            
            let tests: [(name: String, icon: WeatherIcon, expected: String?)] = [
                (
                    name: "clear sky day",
                    icon: WeatherIcon.ClearSkyDay,
                    expected: "sunny"
                ),
                (
                    name: "clear sky night",
                    icon: WeatherIcon.ClearSkyNight,
                    expected: "clear-night"
                ),
                (
                    name: "cloudy day",
                    icon: WeatherIcon.CloudyDay,
                    expected: "cloudy"
                ),
                (
                    name: "cloudy night",
                    icon: WeatherIcon.CloudyNight,
                    expected: "cloudy-night"
                ),
                (
                    name: "rain",
                    icon: WeatherIcon.Rain,
                    expected: "raining"
                ),
                (
                    name: "mist",
                    icon: WeatherIcon.Mist,
                    expected: "mist"
                ),
                (
                    name: "thunder",
                    icon: WeatherIcon.Thunderstorm,
                    expected: "thunder"
                ),
                (
                    name: "snow",
                    icon: WeatherIcon.Snow,
                    expected: "snow"
                ),
                (
                    name: "overcast",
                    icon: WeatherIcon.Overcast,
                    expected: "overcast"
                ),
            ]
            
            tests.forEach { test in
                context("for the icon type " + test.name) {
                    it("should have an image name") {
                        expect(test.icon.imageName).to(equal(test.expected))
                    }
                    
                    it("should return an image") {
                        expect(test.icon.image).toNot(beNil())
                    }
                    
                    it("should load the correct image") {
                        let expected = UIImage(named: test.icon.imageName!)
                        expect(test.icon.image).to(equal(expected))
                    }
                }
            }
        }
        
        describe("the storyboard weather cell") {
            
            var cell: WeatherCell!
            
            beforeEach {
                let storyboard = UIStoryboard(name: "Main",
                    bundle: NSBundle(forClass: WeatherCell.self))
                let tableIdentifier = "WeatherTableViewController"
                let controller = storyboard
                    .instantiateViewControllerWithIdentifier(tableIdentifier) as!
                        WeatherTableViewController
                cell = controller.tableView
                    .dequeueReusableCellWithIdentifier("WeatherCell") as! WeatherCell
                
            }
            
            it("should exist") {
                expect(cell).toNot(beNil())
            }
            
            describe("the UI elements") {
                it("should have an image view") {
                    expect(cell.weatherImageView).toNot(beNil())
                }
                
                it("should have a description label") {
                    expect(cell.descriptionLabel).toNot(beNil())
                }
                
                it("should have a temperature label") {
                    expect(cell.temperatureLabel).toNot(beNil())
                }
                
                it("should have a time label") {
                    expect(cell.timeLabel).toNot(beNil())
                }
            }
            
            context("Adding weather to the cell") {
                var weather: Weather!
                
                beforeEach {
                    weather = Weather(data: ResponseData.Weather.Rain.jsonData)
                    cell.weather = weather
                }
                
                describe("the weather icon") {
                    var imageView: UIImageView!
                    
                    beforeEach {
                        imageView = cell.weatherImageView
                    }
                    
                    it("should have an image") {
                        expect(imageView.image).toNot(beNil())
                    }
                    
                    it("should have the correct image") {
                        let expected = weather.icon?.image
                        expect(imageView.image).to(equal(expected))
                    }
                }
                
                describe("the description label") {
                    
                    var label: UILabel!
                    
                    beforeEach {
                        label = cell.descriptionLabel
                    }
                    
                    it("should have the correct text") {
                        expect(label.text)
                            .to(equal(weather.description.capitalizedString))
                    }
                    
                    it("should have the correct color") {
                        expect(label.textColor).to(equal(Defaults.Color.Primary.base))
                    }
                }
                
                describe("the temperature label") {
                    
                    var label: UILabel!
                    
                    beforeEach {
                        label = cell.temperatureLabel
                    }
                    
                    it("should have the correct text") {
                        let expected = weather.temperature
                            .descriptionForLocale(NSLocale.currentLocale())
                        expect(label.text).to(equal(expected))
                    }
                    
                    it("should have the correct color") {
                        expect(label.textColor).to(equal(Defaults.Color.Primary.base))
                    }
                }
                
                describe("the time label") {
                    
                    var label: UILabel!
                    
                    beforeEach {
                        label = cell.timeLabel
                    }
                    
                    it("should have the correct text") {
                        let formatter = NSDateFormatter()
                        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
                        let expected = formatter.stringFromDate(weather.start)
                        expect(label.text).to(equal(expected))
                    }
                    
                    it("should have the correct color") {
                        expect(label.textColor).to(equal(Defaults.Color.Primary.base))
                    }
                }
                
            }
            
        }
        
    }
}
