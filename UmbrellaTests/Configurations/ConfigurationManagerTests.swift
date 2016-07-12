//
//  ConfigurationManagerTests.swift
//  Umbrella
//
//  Created by Elliott Minns on 11/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
@testable import Umbrella

class ConfigurationManagerSpec: QuickSpec {
    override func spec() {
        
        describe("loading the default configuration") { 
            it("should not throw an error") {
                expect {
                    ConfigurationManager.sharedManager
                }.toNot(throwError())
            }
        }
        
        describe("loading a configuration with data") {
            
            var data: [String: AnyObject]!
            
            context("with correct data") {
                
                beforeEach {
                    data = ["OpenWeatherMap-APPID": "token"]
                }
                
                it("should initialise") {
                    expect {
                        try ConfigurationManager(configurations: data)
                    }.toNot(throwError())
                }
                
                it("should have set the correct token") {
                    let manager = try! ConfigurationManager(configurations: data)
                    expect(manager.openWeatherMapToken).to(equal("token"))
                }
            }
            
            context("with incorrect data") {
                beforeEach {
                    data = ["OpenWeatherMap-APPID": 2]
                }
                
                it("should throw error") {
                    expect {
                        try ConfigurationManager(configurations: data)
                    }.to(throwError())
                }
            }
            
        }
        
    }
}
