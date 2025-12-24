//
//  CGRect+Extensions.swift
//  
//
//  Created by Jonathan Forbes on 24/12/2025.
//

import Foundation
import SwiftUI


extension CGRect {
    var minXY: CGPoint { CGPoint(x: minX, y: minY) }
    var midXY: CGPoint { CGPoint(x: midX, y: midY) }
    var maxXY: CGPoint { CGPoint(x: maxX, y: maxY) }
    var breadth: CGFloat { min(width, height) }
    var length: CGFloat { max(width, height) }
    var aspectRatio: CGFloat { width / height }
    
    func projectedPoint(
        _ point: UnitPoint,
        boundToFrame: Bool = false
    ) -> CGPoint {
        let x = boundToFrame ? max(0, min(1, point.x)) : point.x
        let y = boundToFrame ? max(0, min(1, point.y)) : point.y
        return CGPoint(x: minX + x * width, y: minY + y * height)
    }
    
    func subdivide(
        rows: Double,
        columns: Double
    ) -> [CGRect] {
        var rects = [CGRect]()
        let dx = width / Double(columns)
        let dy = height / Double(rows)
        let size = CGSize(width: dx, height: dy)
        
        for row in 0..<Int(rows) {
            for column in 0..<Int(columns) {
                let origin = CGPoint(
                    x: minX + CGFloat(column) * dx,
                    y: minY + CGFloat(row) * dy
                )
                let item = CGRect(origin: origin, size: size)
                
                rects.append(item)
            }
        }
        return rects
    }
    
    func inset(
        by insets: EdgeInsets
    ) -> CGRect {
        let standard = self.standardized
        let newWidth = standard.width - insets.leading - insets.trailing
        let newHeight = standard.height - insets.top - insets.bottom
        
        if newWidth < 0 || newHeight < 0 {
            return .null
        }
        
        let newOrigin = standard.origin.offsetBy(dx: insets.leading, dy: insets.top)
        let newSize = CGSize(width: newWidth, height: newHeight)
        
        return CGRect(origin: newOrigin, size: newSize)
    }
    
    static func square(
        _ size: CGFloat
    ) -> CGRect {
        CGRect(origin: .zero, size: CGSize(width: size, height: size))
    }
    
    static func square(
        origin: CGPoint,
        size: CGFloat
    ) -> CGRect {
        CGRect(origin: origin, size: CGSize(width: size, height: size))
    }
    
    static func square(
        center: CGPoint,
        size: CGFloat
    ) -> CGRect {
        CGRect(center: center, size: CGSize(width: size, height: size))
    }
    
    init(
        center: CGPoint,
        size: CGSize
    ) {
        let origin = CGPoint(x: center.x - size.width / 2, y: center.y - size.height / 2)
        self.init(origin: origin, size: size)
    }
}

