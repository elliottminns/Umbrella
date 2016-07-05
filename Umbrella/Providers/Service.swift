//
//  Service.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation
import CoreLocation

protocol Service {
    
    associatedtype Data
    
    func get(callback: (result: Result<Data>) -> ())
}