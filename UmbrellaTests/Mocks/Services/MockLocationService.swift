//
//  MockLocationService.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation
@testable import Umbrella

class MockLocationService {
    typealias Data = CLLocation
    
    var called: Bool = false
    var result: Result<CLLocation>
    
    init() {
        let location = CLLocation(latitude: 51.3, longitude: -0.13)
        result = Result<CLLocation>.Success(location)
    }
    
    init(result: Result<CLLocation>) {
        self.result = result
    }
}

extension MockLocationService: Service {
    func get(callback: (result: Result<CLLocation>) -> ()) {
        called = true
        callback(result: result)
    }
}
