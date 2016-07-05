//
//  Result.swift
//  Umbrella
//
//  Created by Elliott Minns on 05/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import Foundation

enum Result<T> {
    case Success(T)
    case Failure(ErrorType)
}