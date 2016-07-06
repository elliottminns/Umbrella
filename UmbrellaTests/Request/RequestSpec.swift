//
//  RequestSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Umbrella

class RequestSpec: QuickSpec {
    
    struct MockRequest: JSONBuildableRequest {
        
        var baseUrl: NSURL?
        
        var path: String
        
        var parameters: [String : AnyObject]
        
        var method: RequestMethod
        
        var headers: [String : String]
        
        init() {
            baseUrl = NSURL(string: "https://test.com")
            path = "/my-test"
            method = .POST
            headers = ["Test-Header": "Something"]
            parameters = ["value": 2]
        }
    }
    
    struct DefaultRequest: JSONBuildableRequest {
        var baseUrl: NSURL?
    }
    
    override func spec() {
        
        describe("a default request object") {
            var request: DefaultRequest!
            
            context("without a base url") {
                beforeEach {
                    request = DefaultRequest(baseUrl: nil)
                }
                
                describe("the NSURLRequest") {
                    var req: NSURLRequest?
                    
                    beforeEach {
                        req = request.buildRequest()
                    }
                    
                    it("should not be nil") {
                        expect(req).toNot(beNil())
                    }
                }
            }
            
            context("with a base url") {
                beforeEach {
                    let base = NSURL(string: "http://base.com")
                    request = DefaultRequest(baseUrl: base)
                }
                
                it("should have the correct default method") {
                    expect(request.method).to(equal(RequestMethod.GET))
                }
                
                it("should have the correct default path") {
                    expect(request.path).to(equal(""))
                }
                
                it("should have the correct default parameters") {
                    expect(request.parameters.count).to(equal(0))
                }
                
                it("should have the correct default headers") {
                    expect(request.headers).to(equal([:]))
                }
                
                describe("building an NSURLRequest") {
                    var req: NSURLRequest?
                    
                    beforeEach {
                        req = request.buildRequest()
                    }
                    
                    it("should exist") {
                        expect(req).toNot(beNil())
                    }
                }
            }
        }
        
        describe("a GET mock request object") {
            let mock: MockRequest = {
                var mock = MockRequest()
                mock.method = .GET
                return mock
            }()
            
            describe("building an NSURLRequest") {
                var request: NSURLRequest?
                
                beforeEach {
                    request = mock.buildRequest()
                }
                
                it("should not be nil") {
                    expect(request).toNot(beNil())
                }
                
                it("should have the correct http method") {
                    expect(request?.HTTPMethod).to(equal("GET"))
                }
                
                describe("the url") {
                    it("should have the correct query added") {
                        let url = request?.URL?.absoluteString
                        expect(url).to(equal("https://test.com/my-test?value=2"))
                    }
                }
                
                it("should have a nil HTTP Body") {
                    expect(request?.HTTPBody).to(beNil())
                }
            }
        }
    
        describe("a mock request object") {
            
            let mock = MockRequest()
            
            describe("building an NSURLRequest") {
                
                var request: NSURLRequest?
                
                beforeEach {
                    request = mock.buildRequest()
                }
                
                it("should not be nil") {
                    expect(request).toNot(beNil())
                }
                
                it("should have the correct http method") {
                    expect(request?.HTTPMethod).to(equal("POST"))
                }
                
                describe("the http body") {
                    
                    var body: NSData?
                    
                    beforeEach {
                        body = request?.HTTPBody
                    }
                    
                    it("should not be nil") {
                        expect(body).toNot(beNil())
                    }
                    
                    it("should equal the parameters as NSData") {
                        let serialize = NSJSONSerialization.dataWithJSONObject
                        let params = try? serialize(mock.parameters, options: [])
                        expect(params).to(equal(body))
                    }
                }
                
                describe("the headers") {
                    
                    var headers: [String: String]?
                    
                    beforeEach {
                        headers = request?.allHTTPHeaderFields
                    }
                    
                    it("should not be nil") {
                        expect(headers).toNot(beNil())
                    }
                    
                    it("should have the correct key") {
                        expect(headers?.keys).to(contain(["Test-Header"]))
                    }
                    
                    it("should have the correct value") {
                        expect(headers?["Test-Header"]).to(equal("Something"))
                    }

                }
                
                describe("the url") {
                    var url: NSURL?
                    
                    beforeEach {
                        url = request?.URL
                    }
                    
                    it("should not be nil") {
                        expect(url).toNot(beNil())
                    }
                    
                    it("should have the correct string value") {
                        let value = url?.absoluteString
                        expect(value).to(equal("https://test.com/my-test"))
                    }
                    
                    it("should have the correct path") {
                        expect(url?.path).to(equal("/my-test"))
                    }
                }
            }
        }
    }
}
