//
//  CGPoint+Extensions.swift
//  
//
//  Created by Jonathan Forbes on 24/12/2025.
//

import SwiftUI

extension CGPoint {
    internal func offsetBy(
        dx: CGFloat,
        dy: CGFloat
    ) -> CGPoint {
        CGPoint(x: x + dx, y: y + dy)
    }
    
    internal func offset(
        magnitude: Double,
        angle: Angle
    ) -> CGPoint {
        let dx = magnitude * cos(angle.radians)
        let dy = magnitude * sin(angle.radians)
        return CGPoint(x: x + dx, y: y + dy)
    }
    
    internal func distance(to point: CGPoint) -> Double {
        let dx = x - point.x
        let dy = y - point.y
        return sqrt(dx * dx + dy * dy)
    }
}

internal func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

internal func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

internal func *(lhs: CGPoint, rhs: CGFloat) -> CGPoint {
    CGPoint(x: lhs.x * rhs, y: lhs.y * rhs)
}
