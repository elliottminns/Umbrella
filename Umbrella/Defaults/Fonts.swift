//
//  Fonts.swift
//  Umbrella
//
//  Created by Elliott Minns on 09/07/2016.
//  Copyright © 2016 Elliott Minns. All rights reserved.
//

import UIKit

extension Defaults {
    enum Fonts {
        case Header
        case Large
        case Normal
        case Small
    }
}

extension Defaults.Fonts {
    var font: UIFont {
        let size: CGFloat
        switch self {
        case .Header: size = 24
        case .Large: size = 20
        case .Normal: size = 18
        case .Small: size = 16
        }
        
        return UIFont.systemFontOfSize(size)
    }
}