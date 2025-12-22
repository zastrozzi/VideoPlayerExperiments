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
    
    public var videoPlayerIsPlaying: Bool = false
    public var interstitialVideoPlayerIsPlaying: Bool = false
    
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
    
    public func loadCurrentVideoPlayerItem(for id: UUID) {
        interstitialVideoPlayer.pause()
        videoPlayer.pause()
        if let item = playerItems.first(where: { $0.id == id }) {
            switch item.contentType {
            case .interstitial:
                currentInterstitialVideoPlayerItem = .init(url: item.source)
                interstitialVideoPlayer.replaceCurrentItem(with: currentInterstitialVideoPlayerItem)
                interstitialVideoPlayer.play()
            case .video:
                currentVideoPlayerItem = .init(url: item.source)
                videoPlayer.replaceCurrentItem(with: currentVideoPlayerItem)
                videoPlayer.play()
            }
        }
    }
    
    public func preloadNextVideoPlayerItem(prevId: UUID, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func loadVideoMetadataForNextItems(prevId: UUID, count: Int, direction: VideoPlayerScrollDirection) {
        // ...
    }
    
    public func toggleVideoPlayback() {
        videoPlayerIsPlaying.toggle()
        if videoPlayerIsPlaying {
            videoPlayer.play()
        } else {
            videoPlayer.pause()
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
    }
}
