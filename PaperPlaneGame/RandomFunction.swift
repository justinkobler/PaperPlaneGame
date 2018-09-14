//
//  RandomFunction.swift
//  Paper Plane Game
//
//  Created by Justin Kobler on 7/26/17.
//  Copyright © 2017 Justin Kobler Apps. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    public static func random(min min: CGFloat, max : CGFloat) -> CGFloat{
        return CGFloat.random() * (max - min) + min
    }
    
}
