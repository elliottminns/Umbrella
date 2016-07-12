//
//  ConfigurationManager.swift
//  Umbrella
//
//  Created by Elliott Minns on 10/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

enum ConfigurationError: ErrorType {
    case MissingOpenWeatherMapAppToken
}

class ConfigurationManager {
    
    static let sharedManager = ConfigurationManager()
    
    let openWeatherMapToken: String
    
    private convenience init() {
        let bundle = NSBundle.mainBundle()
        
        guard let path = bundle.pathForResource("Configurations", ofType: "plist") else {
            fatalError("No configuration found")
        }
        
        guard let configurations = NSDictionary(contentsOfFile: path) else {
            fatalError("Incorrect file format for configurations")
        }
        
        do {
            try self.init(configurations: configurations as! [String: AnyObject])
        } catch {
            fatalError("Missing configuration files")
        }
    }
    
    init(configurations: [String: AnyObject]) throws {
        guard let openWeatherToken = configurations["OpenWeatherMap-APPID"] as? String else {
            throw ConfigurationError.MissingOpenWeatherMapAppToken
        }
        openWeatherMapToken = openWeatherToken
    }
    
}
