//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import Foundation

extension VideoService {
    public func startAutoplay(for id: UUID) {
        if let item = playerItems.first(where: { $0.id == id }) {
            switch item.itemType {
            case .interstitial:
                print("Starting Autoplay for Interstitial: \(item.title)")
                interstitialVideoPlayer.play()
                interstitialVideoPlayerIsPlaying = true
            case .content:
                print("Starting Autoplay for Content: \(item.title)")
                contentVideoPlayer.play()
                contentVideoPlayerIsPlaying = true
            }
        }
    }
    
    public func stopAutoplay() {
        interstitialVideoPlayer.pause()
        contentVideoPlayer.pause()
    }
    
    public func toggleContentVideoPlayback(for id: UUID) {
        contentVideoPlayerIsPlaying.toggle()
        if contentVideoPlayerIsPlaying {
            currentPlayerItemId = id
            if currentContentVideoProgress == 1 {
                self.contentVideoPlayer.seek(to: .zero)
            }
            contentVideoPlayer.play()
        } else {
            contentVideoPlayer.pause()
        }
    }
    
    public func toggleInterstitialVideoPlayback(for id: UUID) {
        interstitialVideoPlayerIsPlaying.toggle()
        if interstitialVideoPlayerIsPlaying {
            currentPlayerItemId = id
            if currentInterstitialVideoProgress == 1 {
                self.interstitialVideoPlayer.seek(to: .zero)
            }
            interstitialVideoPlayer.play()
        } else {
            interstitialVideoPlayer.pause()
        }
    }
}
