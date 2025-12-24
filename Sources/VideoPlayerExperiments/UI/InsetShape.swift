//
//  InsetShape.swift
//  
//
//  Created by Jonathan Forbes on 24/12/2025.
//

import SwiftUI

public struct InsetShape<Content: Shape>: InsettableShape {
    public var shape: Content
    public var insets: EdgeInsets
    
    public init(shape: Content, inset: CGFloat) {
        self.shape = shape
        self.insets = EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
    
    public init(shape: Content, insets: EdgeInsets) {
        self.shape = shape
        self.insets = insets
    }
    
    public func inset(by amount: CGFloat) -> some InsettableShape {
        var me = self
        me.insets = EdgeInsets(top: amount, leading: amount, bottom: amount, trailing: amount)
        return me
    }
    
    public func path(in rect: CGRect) -> Path {
        return shape.path(in: rect.inset(by: insets))
    }
    
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
        shape.sizeThatFits(proposal)
    }
}

extension Shape {
    func inset(amount: CGFloat) -> InsetShape<Self> {
        InsetShape(shape: self, inset: amount)
    }
    
    func inset(by insets: EdgeInsets) -> InsetShape<Self> {
        InsetShape(shape: self, insets: insets)
    }
}
