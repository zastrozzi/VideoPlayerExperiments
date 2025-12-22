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
    
    public var contentVideoPlayerIsPlaying: Bool = false
    public var interstitialVideoPlayerIsPlaying: Bool = false
    
    @ObservationIgnored public var contentVideoPlayer: AVPlayer = .init()
    @ObservationIgnored public var interstitialVideoPlayer: AVPlayer = .init()
    
    @ObservationIgnored public var currentContentVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextContentVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousContentVideoPlayerItem: AVPlayerItem? = nil
    
    @ObservationIgnored public var currentInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousInterstitialVideoPlayerItem: AVPlayerItem? = nil
    
    public func isCurrentPlayerItem(_ id: UUID) -> Bool {
        id == currentPlayerItemId
    }
    
    public func loadVideoPlayerItem(for id: UUID) {
        if let item = playerItems.first(where: { $0.id == id }) {
            switch item.itemType {
            case .interstitial:
                currentInterstitialVideoPlayerItem = .init(url: item.source)
                interstitialVideoPlayer.replaceCurrentItem(with: currentInterstitialVideoPlayerItem)
            case .content:
                currentContentVideoPlayerItem = .init(url: item.source)
                contentVideoPlayer.replaceCurrentItem(with: currentContentVideoPlayerItem)
            }
        }
    }
    
    public func stopAutoplay() {
        interstitialVideoPlayer.pause()
        contentVideoPlayer.pause()
    }
    
    public func startAutoplay(for id: UUID) {
        currentPlayerItemId = id
        if let item = playerItems.first(where: { $0.id == id }) {
            switch item.itemType {
            case .interstitial:
                interstitialVideoPlayer.play()
            case .content:
                contentVideoPlayer.play()
            }
        }
    }
    
    public func preloadNextVideoPlayerItem(prevId: UUID, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func loadVideoMetadataForNextItems(prevId: UUID, count: Int, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func toggleContentVideoPlayback() {
        contentVideoPlayerIsPlaying.toggle()
        if contentVideoPlayerIsPlaying {
            contentVideoPlayer.play()
        } else {
            contentVideoPlayer.pause()
        }
    }
    
    public func toggleInterstitialVideoPlayback() {
        interstitialVideoPlayerIsPlaying.toggle()
        if interstitialVideoPlayerIsPlaying {
            interstitialVideoPlayer.play()
        } else {
            interstitialVideoPlayer.pause()
        }
    }
}

extension VideoService {
    public func loadSampleItems() {
        self.playerItems = .init(VideoPlayerSamples.videoPlayerItems)
        if let first = self.playerItems.first {
            self.stopAutoplay()
            self.loadVideoPlayerItem(for: first.id)
            self.startAutoplay(for: first.id)
        }
    }
}
