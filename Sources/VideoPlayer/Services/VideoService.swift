//
//  File.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation
import SwiftUI
import Collections
import AVKit

@Observable
public class VideoService {
    public var currentPlayerItemId: UUID? = nil
    public var playerItems: Deque<VideoPlayerItem> = []
    
    @ObservationIgnored public var videoPlayer: AVPlayer = .init()
    @ObservationIgnored public var interstitialVideoPlayer: AVPlayer = .init()
    
    @ObservationIgnored public var currentVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousVideoPlayerItem: AVPlayerItem? = nil
    
    @ObservationIgnored public var currentInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousInterstitialVideoPlayerItem: AVPlayerItem? = nil
    
    public func isCurrentPlayerItem(_ id: UUID) -> Bool {
        id == currentPlayerItemId
    }
    
    public func preloadNextVideoPlayerItem(prevId: UUID, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func loadVideoMetadataForNextItems(prevId: UUID, count: Int, direction: VideoPlayerScrollDirection) {
        // ...
    }
}

extension VideoService {
    public func loadSampleItems() {
        self.playerItems = [
            .video(meta: .init(title: "Video 1")),
            .video(meta: .init(title: "Video 2")),
            .video(meta: .init(title: "Video 3")),
            .interstitial(meta: .init(title: "Advert 1")),
            .video(meta: .init(title: "Video 4")),
            .video(meta: .init(title: "Video 5")),
            .video(meta: .init(title: "Video 6")),
            .interstitial(meta: .init(title: "Advert 2")),
            .video(meta: .init(title: "Video 7")),
            .video(meta: .init(title: "Video 8")),
            .video(meta: .init(title: "Video 9"))
        ]
    }
}
