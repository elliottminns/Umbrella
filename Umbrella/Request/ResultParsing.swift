//
//  ResultParsing.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

protocol ResultParsing {
    
    associatedtype ParsedType
    
    func parseData(data: NSData) -> ParsedType?
}

protocol StringParsing: ResultParsing {}

extension StringParsing {
    
    typealias ParsedType = String
    
    func parseData(data: NSData) -> String? {
        return String(data: data, encoding: NSUTF8StringEncoding)
    }
}

protocol JSONConstructable {
    init?(data: [String: AnyObject])
}

protocol JSONParsing: ResultParsing {
    associatedtype JSONType: JSONConstructable
}

extension JSONParsing {
    
    func parseData(data: NSData) -> JSONType? {
        
        let serialize = NSJSONSerialization.JSONObjectWithData
        
        guard let serial = try? serialize(data, options: []),
            json = serial as? [String: AnyObject] else {
            return nil
        }
        
        return JSONType(data: json)
    }
}