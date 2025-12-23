//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation

public enum VideoPlayerItem: Identifiable, Sendable {
    case content(meta: ContentVideoMetadata)
    case interstitial(meta: InterstitialVideoMetadata)
    
    public var id: UUID {
        switch self {
        case let .interstitial(meta): meta.id
        case let .content(meta): meta.id
        }
    }
    
    public var title: String {
        switch self {
        case let .interstitial(meta): meta.title
        case let .content(meta): meta.title
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
        case let .content(meta): meta.source
        }
    }
    
    public var thumbnailSource: URL {
        switch self {
        case let .interstitial(meta): meta.thumbnailSource
        case let .content(meta): meta.thumbnailSource
        }
    }
    
    public var itemType: VideoPlayerItemType {
        if case .interstitial = self {
            .interstitial
        } else {
            .content
        }
    }
    
    public var asInterstitial: InterstitialVideoMetadata? {
        if case let .interstitial(meta) = self {
            meta
        } else {
            nil
        }
    }
    
    public var asContent: ContentVideoMetadata? {
        if case let .content(meta) = self {
            meta
        } else {
            nil
        }
    }
}

