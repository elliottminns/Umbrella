//
//  LocationServiceSpec.swift
//  Umbrella
//
//  Created by Elliott Minns on 07/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Quick
import Nimble
import CoreLocation
@testable import Umbrella


class MockLocationManager: CLLocationManager {
    
    var locationResponse: CLLocation?
    
    var error: NSError? = nil
    
    var requestLocationCalled: Bool = false
    
    var requestWhenInUseCalled: Bool = false
    
    var startUpdatingLocationCalled: Bool = false
    
    var stopUpdatingLocationCalled: Bool = false
    
    var returnState: CLAuthorizationStatus = .AuthorizedWhenInUse
    
    static var authStatus = CLAuthorizationStatus.AuthorizedWhenInUse
    
    override static func authorizationStatus() -> CLAuthorizationStatus {
        return authStatus
    }
    
    convenience override init() {
        let location = CLLocation(latitude: 51.03, longitude: -0.13)
        self.init(location: location)
    }
    
    init(error: NSError?) {
        locationResponse = nil
        self.error = error
        super.init()
    }
    
    init(location: CLLocation) {
        locationResponse = location
        super.init()
    }
    
    override func requestLocation() {
        requestLocationCalled = true
        if let location = locationResponse {
            delegate?.locationManager!(self, didUpdateLocations: [location])
        } else if let error = error {
            delegate?.locationManager!(self, didFailWithError: error)
        }
    }
    
    override func startUpdatingLocation() {
        requestLocationCalled = true
        startUpdatingLocationCalled = true
        if let location = locationResponse {
            delegate?.locationManager!(self, didUpdateLocations: [location])
        } else if let error = error {
            delegate?.locationManager!(self, didFailWithError: error)
        }
    }
    
    override func stopUpdatingLocation() {
        stopUpdatingLocationCalled = true
    }
    
    override func requestWhenInUseAuthorization() {
        requestWhenInUseCalled = true
        MockLocationManager.authStatus = returnState
        delegate?.locationManager!(self, didChangeAuthorizationStatus: returnState)
    }
}


class LocationServiceSpec: QuickSpec {
    
    override func spec() {
        
        func error(fromResult result: Result<CLLocation>?) -> LocationServiceError? {
            guard let result = result else { return nil }
            let error: LocationServiceError?
            switch result {
            case .Failure(let e): error = e as? LocationServiceError
            case .Success(_): error = nil
            }
            return error
        }
        
        var service: LocationService!
        var manager: MockLocationManager!
        
        beforeEach {
            manager = MockLocationManager()
            service = LocationService(locationManager: manager)
        }
        
        describe("behaviour for states") {
            
            var result: Result<CLLocation>?
            
            beforeEach {
                service.callback = { res in
                    result = res
                }
            }
            
            afterEach {
                result = nil
            }
            
            context("with a state of not determined") {
                beforeEach {
                    service.behaviour(forStatus: .NotDetermined)
                }
                
                it("should call the location manager to authorize") {
                    expect(manager.requestWhenInUseCalled).to(beTrue())
                }
            }
            
            context("with a state of restricted") {
                
                beforeEach {
                    service.behaviour(forStatus: .Restricted)
                }
                
                it("should return an error of type LocationRestricted") {
                    let error = error(fromResult: result)
                    expect(error).to(equal(LocationServiceError.LocationRestricted))
                }
            }
            
            context("with a state of always authorized") {
                beforeEach {
                    service.behaviour(forStatus: .AuthorizedAlways)
                }
                
                it("should request the location from the manager") {
                    expect(manager.requestLocationCalled).to(beTrue())
                }
            }
            
            context("with a state of when in use authorized") {
                beforeEach {
                    service.behaviour(forStatus: .AuthorizedWhenInUse)
                }
                
                it("should request the location from the manager") {
                    expect(manager.requestLocationCalled).to(beTrue())
                }
            }
            
            context("with state of denied") {
                
                beforeEach {
                    service.behaviour(forStatus: .Denied)
                }
                
                it("should return an error of type LocationDenied") {
                    let error = error(fromResult: result)
                    expect(error).to(equal(LocationServiceError.LocationDenied))
                }
            }
            
        }
        
        describe("obtaining a location") {
            
            var result: Result<CLLocation>?
            
            afterEach {
                result = nil
            }
            
            func getResult() {
                waitUntil { done in
                    service.get { res in
                        result = res
                        done()
                    }
                }
            }
            
            context("using a mock manager which is unsuccessful") {
                beforeEach {
                    manager.locationResponse = nil
                    manager.error = NSError(domain: "com.locationerror",
                        code: 0, userInfo: nil)
                    getResult()
                }
                
                describe("the result") {
                    
                    it("should be of type failure") {
                        let isFailure: Bool
                        
                        switch result! {
                        case .Failure(_): isFailure = true
                        case .Success(_): isFailure = false
                        }
                        
                        expect(isFailure).to(beTrue())
                    }
                    
                    it("should have an error") {
                        let error = error(fromResult: result)
                        expect(error).toNot(beNil())
                        
                        if let error = error {
                            expect(error).to(equal(LocationServiceError.LocationFailed))
                        }
                    }
                }
                
            }
            
            context("using a mock manager which is successful") {
                
                context("with an authorization status of not determined") {
                    
                    beforeEach {
                        MockLocationManager.authStatus = .NotDetermined
                    }
                    
                    describe("the location manager") {
                        it("should have had request when in use called") {
                            getResult()
                            expect(manager.requestWhenInUseCalled).to(beTrue())
                        }
                    }
                    
                    context("with an authorization result of Denied") {
                        beforeEach {
                            manager.returnState = .Denied
                            getResult()
                        }
                        
                        describe("the result") {
                            it("should not be nil") {
                                expect(result).toNot(beNil())
                            }
                            
                            it("should be of type failure") {
                                let isSuccess: Bool
                                switch result! {
                                case .Failure(_): isSuccess = false
                                case .Success(_): isSuccess = true
                                }
                                expect(isSuccess).to(beFalse())
                            }
                            
                            it("should have the correct error type") {
                                let error: ErrorType?
                                
                                switch result! {
                                case .Failure(let e): error = e
                                default: error = nil
                                }
                                
                                expect(error).toNot(beNil())
                                
                                if let error = error {
                                    
                                    let locationError = error as? LocationServiceError
                                    
                                    expect(locationError).toNot(beNil())
                                    if let locError = locationError {
                                        expect(locError).to(equal(LocationServiceError.LocationDenied))
                                    }
                                }
                            }
                        }
                    }
                    
                    context("with an authorization result of WhenInUse") {
                        
                        beforeEach {
                            manager.returnState = .AuthorizedWhenInUse
                            getResult()
                        }
                        
                        describe("the result") {
                            
                            it("should not be nil") {
                                expect(result).toNot(beNil())
                            }
                            
                            it("should be of type success") {
                                
                                let isSuccess: Bool
                                
                                switch result! {
                                case .Success(_): isSuccess = true
                                case .Failure(_): isSuccess = false
                                }
                                
                                expect(isSuccess).to(beTrue())
                            }
                            
                            it("should have the correct location associated") {
                                var location: CLLocation?
                                
                                switch result! {
                                case .Success(let loc): location = loc
                                case .Failure(_): location = nil
                                }
                                
                                expect(location).toNot(beNil())
                                
                                if let coords = location?.coordinate {
                                    expect(coords.latitude).to(equal(51.03))
                                    expect(coords.longitude).to(equal(-0.13))
                                }
                                
                            }
                        }
                    }
                }
                
            }
        }
    }
    
}