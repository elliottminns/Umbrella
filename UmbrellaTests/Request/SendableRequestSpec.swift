//
//  SendableRequestSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import Umbrella

class MockSendable: Request, JSONBuildableRequest, StringParsing, SendableRequest {
    var baseUrl: NSURL?
}

class MockFailable: Request, JSONBuildableRequest, SendableRequest, ResultParsing {
    var baseUrl: NSURL? 
    typealias ParsedType = String
    func parseData(data: NSData) -> ParsedType? {
        return nil
    }
}

class SendableRequestSpec: QuickSpec {

    override func spec() {
        
        describe("a mock sendable request") {
            
            var mock: MockSendable!
            var session: MockRequestClient!
            
            var data: NSData?

            var error: NSError?
            
            beforeEach {
                mock = MockSendable()
            }
            
            describe("using a mock session") {
                
                context("with returns data") {
                    
                    beforeEach {
                        error = nil
                    }
                    
                    context("which is invalid") {
                        beforeEach {
                            let value: NSData? = NSData()
                            data = value
                            session = MockRequestClient(data: data,
                                response: nil, error: nil)
                        }
                        
                        describe("performing the request") {
                            
                            describe("the result") {
                                
                                var result: Result<String>?
                                
                                beforeEach {
                                    
                                    let failer = MockFailable()
                                    
                                    failer.sendRequest(withClient: session) { res in
                                        result = res
                                    }
                                }
                                
                                it("should not be nil") {
                                    expect(result).toNot(beNil())
                                }
                                
                                it("should be a failure") {
                                    var isSuccess = false
                                    switch result! {
                                    case .Success(_):
                                        isSuccess = true
                                    case .Failure(_):
                                        isSuccess = false
                                    }
                                    
                                    expect(isSuccess).to(beFalse())
                                }
                                
                                it("should have an error of correct type") {
                                    var error: ErrorType?
                                    switch result! {
                                    case .Failure(let err):
                                        error = err
                                    default: break
                                    }
                                    
                                    expect(error is RequestError).to(beTrue())
                                }
                            }
                        }
                    }
                    
                    context("which is valid") {
                        beforeEach {
                            let value = "Hello World"
                            data = value.dataUsingEncoding(NSUTF8StringEncoding)
                            session = MockRequestClient(data: data,
                                response: nil, error: error)
                        }
                        
                        describe("performing the request") {
                            
                            var result: Result<String>?
                            
                            beforeEach {
                                mock.sendRequest(withClient: session) { res in
                                    result = res
                                }
                            }
                            
                            describe("the result") {
                                
                                it("should not be nil") {
                                    expect(result).toNot(beNil())
                                }
                                
                                it("should be of type success") {
                                    
                                    var isSuccess = false
                                    switch result! {
                                    case .Success(_):
                                        isSuccess = true
                                    case .Failure(_):
                                        isSuccess = false
                                    }
                                    
                                    expect(isSuccess).to(beTrue())
                                }
                                
                                it("should have the correct string value") {
                                    
                                    var value = ""
                                    
                                    switch result! {
                                    case .Success(let v):
                                        value = v
                                    case .Failure(_):
                                        break
                                    }
                                    
                                    expect(value).to(equal("Hello World"))
                                }
                            }
                        }
                    }
                }
                
                context("which returns an error") {
                    beforeEach {
                        error = NSError(domain: "com.testerror", code: 1,
                            userInfo: nil)
                        session = MockRequestClient(data: nil, response: nil,
                            error: error)
                    }
                    
                    describe("making a request") {
                        
                        var result: Result<String>?
                        beforeEach {
                            mock.sendRequest(withClient: session) { res in
                                result = res
                            }
                        }
                        
                        describe("the result") {
                            
                            it("should be of type failure") {
                                
                                var failure = false
                                
                                switch result! {
                                case .Failure(_): failure = true
                                default: failure = false
                                }
                                
                                expect(failure).to(beTrue())
                            }
                            
                            it("should have the correct error type") {
                                var error: ErrorType?
                                
                                switch result! {
                                case .Failure(let err): error = err
                                default: error = nil
                                }
                                
                                expect(error).toNot(beNil())
                            }
                        }
                    }
                }
            }
        }
    }
}
