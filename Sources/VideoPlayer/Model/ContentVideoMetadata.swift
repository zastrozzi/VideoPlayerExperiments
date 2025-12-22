//
//  File.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation

public struct ContentVideoMetadata: Identifiable, Codable, Equatable, Sendable {
    public var id: UUID
    public var title: String
    public var source: URL
    public var thumbnailSource: URL
    
    public init(
        id: UUID = .init(),
        title: String,
        source: URL,
        thumbnailSource: URL
    ) {
        self.id = id
        self.title = title
        self.source = source
        self.thumbnailSource = thumbnailSource
    }
}
