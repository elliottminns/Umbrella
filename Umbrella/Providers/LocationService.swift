//
//  LocationService.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import CoreLocation

enum LocationServiceError: ErrorType {
    case LocationDenied
    case LocationRestricted
    case LocationFailed
}

class LocationService: NSObject {
    
    typealias Data = CLLocation
    
    let locationManager: CLLocationManager
    
    var callback: ((result: Result<Data>) -> ())?
    
    var currentStatus: CLAuthorizationStatus?
    
    override convenience init() {
        let manager = CLLocationManager()
        self.init(locationManager: manager)
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func error(withType type: LocationServiceError) {
        let result = Result<Data>.Failure(type)
        callback?(result: result)
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if #available(iOS 9.0, *) {
            
        } else {
            manager.stopUpdatingLocation()
        }
        
        let result = Result<Data>.Success(location)
        callback?(result: result)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if #available(iOS 9.0, *) {
        } else {
            manager.stopUpdatingLocation()
        }
        self.error(withType: .LocationFailed)
    }
    
    func locationManager(manager: CLLocationManager,
                         didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != currentStatus {
            currentStatus = status
            behaviour(forStatus: status)
        }
    }
}

extension LocationService: Service {
    
    func get(callback: (result: Result<Data>) -> ()) {
        
        let arguments = NSProcessInfo.processInfo().arguments
        
        if arguments.contains("MOCK_NO_LOCATION") {
            let error = LocationServiceError.LocationFailed
            return callback(result: Result.Failure(error))
        }
        
        self.callback = callback
        
        let status = locationManager.dynamicType.authorizationStatus()
        
        if currentStatus == nil {
           currentStatus = status
        }
        
        behaviour(forStatus: status)
    }
    
    func behaviour(forStatus status: CLAuthorizationStatus) {
        switch status {
            
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                locationManager.startUpdatingLocation()
            }
            
        case .Denied:
            error(withType: .LocationDenied)
            
        case .Restricted:
            error(withType: .LocationRestricted)
            
        case .NotDetermined:
            requestLocationAuthorization()
        }
    }
}

