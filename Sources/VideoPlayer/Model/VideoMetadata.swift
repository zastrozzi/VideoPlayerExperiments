//
//  File.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation

public struct VideoMetadata: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var title: String
    
    public init(id: UUID = .init(), title: String) {
        self.id = id
        self.title = title
    }
}
