//
//  File.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

protocol TestData {
    var json: String { get }
}

extension TestData {
    
    var data: NSData? {
        return json.dataUsingEncoding(NSUTF8StringEncoding)
    }
    
    var jsonData: [String: AnyObject] {
        
        guard let data = json.dataUsingEncoding(NSUTF8StringEncoding) else {
            return [:]
        }
        
        let serialize = NSJSONSerialization.JSONObjectWithData
        
        guard let obj = try? serialize(data, options: []),
        jsonData = obj as? [String: AnyObject] else {
            return [:]
        }
     
        return jsonData
    }
    
}