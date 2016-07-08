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
        let task = session.dataTaskWithRequest(request, completionHandler: callback)
        task.resume()
    }
}

class Requester {
    static var defaultClient: RequestClient = SessionClient()
}