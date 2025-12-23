//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation
import SwiftUI
import Collections
import AVKit

@Observable
public class VideoService: @unchecked Sendable {
    public var currentPlayerItemId: UUID? = nil
    public var playerItems: Deque<VideoPlayerItem> = []
    
    public var contentVideoPlayerIsPlaying: Bool = false
    public var interstitialVideoPlayerIsPlaying: Bool = false
    
    @ObservationIgnored internal var interstitialVideoProgressObserverAdded: Bool = false
    @ObservationIgnored internal var interstitialVideoProgressObserver: Any? = nil
    public var currentInterstitialVideoProgress: CGFloat = 0
    public var currentInterstitialVideoSecondsRemaining: Double = 0.0
    public var interstitialPlayerObservationFrequency: Double = 0.5
    
    @ObservationIgnored internal var contentVideoProgressObserverAdded: Bool = false
    @ObservationIgnored internal var contentVideoProgressObserver: Any? = nil
    public var currentContentVideoProgress: CGFloat = 0
    public var contentPlayerObservationFrequency: Double = 0.5
    
    @ObservationIgnored public var contentVideoPlayer: AVPlayer = .init()
    @ObservationIgnored public var interstitialVideoPlayer: AVPlayer = .init()
    
    @ObservationIgnored public var currentContentVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextContentVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousContentVideoPlayerItem: AVPlayerItem? = nil
    
    @ObservationIgnored public var currentInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var nextInterstitialVideoPlayerItem: AVPlayerItem? = nil
    @ObservationIgnored public var previousInterstitialVideoPlayerItem: AVPlayerItem? = nil
    
    public var videoPlayerNamespace: Namespace = .init()
    
    public init() {
        print("Initialising VideoService")
        addInterstitialVideoProgressObserver()
        addContentVideoProgressObserver()
    }
}

