//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import Foundation

extension VideoService {
    public func loadVideoPlayerItem(for id: UUID, settingAsCurrent: Bool = false) {
        if settingAsCurrent { currentPlayerItemId = id }
        if let item = playerItems.first(where: { $0.id == id }) {
            switch item.itemType {
            case .interstitial:
                print("Loading Interstitial: \(item.title)")
                currentInterstitialVideoPlayerItem = .init(url: item.source)
                interstitialVideoPlayer.replaceCurrentItem(with: currentInterstitialVideoPlayerItem)
            case .content:
                print("Loading Content: \(item.title)")
                currentContentVideoPlayerItem = .init(url: item.source)
                contentVideoPlayer.replaceCurrentItem(with: currentContentVideoPlayerItem)
            }
        }
    }
    
    public func preloadNextVideoPlayerItem(prevId: UUID, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func loadVideoMetadataForNextItems(prevId: UUID, count: Int, direction: VideoPlayerScrollDirection) {
        // ...
    }
}
