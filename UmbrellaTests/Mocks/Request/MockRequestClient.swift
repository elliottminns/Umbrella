//
//  MockRequestClient.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
@testable import Umbrella

class MockRequestClient: RequestClient {
    
    var called: Bool {
        return sessionCalled
    }
    
    var sessionCalled = false
    
    var request: NSURLRequest?
    
    var data: NSData?
    
    var response: NSURLResponse?
    
    var error: NSError?
    
    init(data: NSData?, response: NSURLResponse?, error: NSError?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    
    func perform(request request: NSURLRequest, callback: ClientCallback) {
        self.request = request
        self.sessionCalled = true
        return callback(data: data, response: response, error: error)
    }
}