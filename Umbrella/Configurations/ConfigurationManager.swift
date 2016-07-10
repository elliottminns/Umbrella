//
//  ConfigurationManager.swift
//  Umbrella
//
//  Created by Elliott Minns on 10/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

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
        
        self.init(configurations: configurations as! [String: AnyObject])
    }
    
    init(configurations: [String: AnyObject]) {
        openWeatherMapToken = configurations["OpenWeatherMap-APPID"] as! String
    }
    
}
