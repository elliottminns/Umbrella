//
//  Request.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

enum RequestMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

struct RequestError: ErrorType {
    let message: String
}

protocol Request {

    var baseUrl: NSURL? { get }
    var method: RequestMethod { get }
    var path: String { get }
    var parameters: [String: AnyObject] { get }
    var headers: [String: String] { get }
}

// Set up default attributes
extension Request {
    var method: RequestMethod { return .GET }
    var path: String { return "" }
    var parameters: [String: AnyObject] { return [:] }
    var headers: [String: String] { return [:] }
}

protocol BuildableRequest: Request {
    func buildRequest() -> NSURLRequest?
}

protocol JSONBuildableRequest: BuildableRequest { }

extension JSONBuildableRequest {
    
    func buildRequest() -> NSURLRequest? {
        
        guard let url = NSURL(string: path, relativeToURL: baseUrl),
            data = try? NSJSONSerialization.dataWithJSONObject(parameters,
                                                               options: []) else {
            return nil
        }
        
        let urlRequest = NSMutableURLRequest(URL: url) 
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.HTTPMethod = method.rawValue
        
        if method == .GET {
            if let comps = createComponents(forUrl: url) {
                urlRequest.URL = comps.URL
            }
        } else {
            urlRequest.HTTPBody = data
        }
        
        return urlRequest
    }
    
    func createComponents(forUrl url: NSURL) -> NSURLComponents? {
        let comps = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        let queryItems: [NSURLQueryItem] = parameters.map {
            let set = NSCharacterSet.URLQueryAllowedCharacterSet()
            let value = "\($0.1)".stringByAddingPercentEncodingWithAllowedCharacters(set)
            return NSURLQueryItem(name: $0.0, value: value)
        }
        comps?.queryItems = queryItems
        return comps
    }
}

protocol SendableRequest: BuildableRequest, ResultParsing {}

extension SendableRequest {
    
    func sendRequest(callback: (result: Result<ParsedType>) -> ()) {
        
        let client = Requester.defaultClient
        
        sendRequest(withClient: client, callback: callback)
    }
    
    func sendRequest(withClient client: RequestClient,
                                callback: (result: Result<ParsedType>) -> ()) {
        
        guard let request = buildRequest() else {
            let error = RequestError(message: "Could not build request")
            let result = Result<ParsedType>.Failure(error)
            return callback(result: result)
        }
        
        client.perform(request: request) { (data, response, error) in
            
            var err: ErrorType?
            
            var obj: ParsedType?
            
            defer {
                
                let result: Result<ParsedType>
                
                if let err = err {
                    result = Result.Failure(err)
                } else if let obj = obj {
                    result = Result.Success(obj)
                } else {
                    let error = RequestError(message: "Something went wrong")
                    result = Result.Failure(error)
                }
                
                callback(result: result)
            }
            
            if let error = error {
                err = error
                return
            }
            
            guard let data = data else {
                err = RequestError(message: "No data in response")
                return
            }
            
            guard let parsed = self.parseData(data) else {
                err = RequestError(message: "Could not parse result")
                return
            }
            
            obj = parsed
        }

    }
}