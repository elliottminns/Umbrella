//
//  Colors.swift
//  Umbrella
//
//  Created by Elliott Minns on 06/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

struct Defaults {}

extension Defaults {
    enum Color {
        case Blue
        case Red
        case Green
        case Gray
        case BlueGray
    }
}

extension Defaults.Color {
    var base: UIColor {
        switch self {
        case .Blue: return UIColor(red: 0.169, green: 0.596, blue: 0.941, alpha: 1)
        case .Red: return UIColor(red: 0.937, green: 0.267, blue: 0.239, alpha: 1)
        case .Green: return UIColor(red: 0.314, green: 0.682, blue: 0.333, alpha: 1)
        case .Gray: return UIColor(red: 0.62, green: 0.62, blue: 0.62, alpha: 1)
        case .BlueGray: return UIColor(red: 0.38, green: 0.49, blue: 0.541, alpha: 1)
        }
    }
}