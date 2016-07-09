//
//  RequestClient.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

typealias ClientCallback =  (data: NSData?,
    response: NSURLResponse?, error: NSError?) -> ()

protocol RequestClient {
    func perform(request request: NSURLRequest,
                         callback: ClientCallback)
}

class SessionClient: RequestClient {
    
    func perform(request request: NSURLRequest, callback: ClientCallback) {
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, res, err in
            dispatch_async(dispatch_get_main_queue(), { 
                callback(data: data, response: res, error: err)
            })
        }
        task.resume()
    }
}

class Requester {
    static var defaultClient: RequestClient = SessionClient()
}