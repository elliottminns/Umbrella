//
//  WeatherHeaderViewSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class WeatherHeaderViewSpec: QuickSpec {
    
    override func spec() {
        
        describe("the weather header view") {
            
            var forecast: Forecast!
            var view: WeatherHeaderView!
            
            beforeEach {
                forecast = Forecast(data: ResponseData.Forecast.London.jsonData)
                view = WeatherHeaderView(forecast: forecast)
            }
            
            it("should have the correct color") {
                expect(view.backgroundColor).to(equal(Defaults.Color.Primary.base))
            }
            
            describe("the location label") {
                var label: UILabel!
                
                beforeEach {
                    label = view.locationLabel
                }
                
                it("should be in the view") {
                    expect(label.superview).to(equal(view))
                }
                
                it("should have the correct text color") {
                    expect(label.textColor).to(equal(Defaults.Color.Secondary.base))
                }
                
                it("should be centered") {
                    expect(label.textAlignment).to(equal(NSTextAlignment.Center))
                }
                
                it("should have the right size") {
                    expect(label.font).to(equal(Defaults.Fonts.Header.font))
                }
                
                it("should have the correct text") {
                    expect(label.text).to(equal(forecast.placeName))
                }
            }
            
            describe("the temperature label") {
                var label: UILabel!
                
                beforeEach {
                    label = view.temperatureLabel
                }
                
                it("should be in the view") {
                    expect(label.superview).to(equal(view))
                }
                
                it("should have the correct text color") {
                    expect(label.textColor).to(equal(Defaults.Color.Secondary.base))
                }
                
                it("should be centered") {
                    expect(label.textAlignment)
                        .to(equal(NSTextAlignment.Center))
                }
                
                it("should have the right size") {
                    expect(label.font).to(equal(Defaults.Fonts.Header.font))
                }
                
                it("should have the correct text") {
                    let expected = forecast.currentTemperature?
                        .descriptionForLocale(NSLocale.currentLocale())
                    expect(label.text).to(equal(expected))
                }
            }
            
            describe("the description label") {
                var label: UILabel!
                
                beforeEach {
                    label = view.descriptionLabel
                }
                
                it("should be in the view") {
                    expect(label.superview).to(equal(view))
                }
                
                it("should have the correct text color") {
                    expect(label.textColor).to(equal(Defaults.Color.Secondary.base))
                }
                
                it("should be centered") {
                    expect(label.textAlignment).to(equal(NSTextAlignment.Center))
                }
                
                it("should have the right size") {
                    expect(label.font).to(equal(Defaults.Fonts.Large.font))
                }
                
                it("should have the correct text") {
                    let expected = forecast.weather.first?.description.capitalizedString
                    expect(label.text).to(equal(expected))
                }
            }
            
        }
    }
}
