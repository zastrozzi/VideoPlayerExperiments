//
//  File.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation

public enum VideoPlayerItem: Identifiable, Sendable {
    case video(meta: VideoMetadata)
    case interstitial(meta: InterstitialVideoMetadata)
    
    public var id: UUID {
        switch self {
        case let .interstitial(meta): meta.id
        case let .video(meta): meta.id
        }
    }
    
    public var title: String {
        switch self {
        case let .interstitial(meta): meta.title
        case let .video(meta): meta.title
        }
    }
    
    public var isInterstitial: Bool {
        if case .interstitial = self {
            true
        } else {
            false
        }
    }
    
    public var source: URL {
        switch self {
        case let .interstitial(meta): meta.source
        case let .video(meta): meta.source
        }
    }
    
    public var thumbnailSource: URL {
        switch self {
        case let .interstitial(meta): meta.thumbnailSource
        case let .video(meta): meta.thumbnailSource
        }
    }
    
    public var contentType: VideoPlayerContentType {
        if case .interstitial = self {
            .interstitial
        } else {
            .video
        }
    }
}

