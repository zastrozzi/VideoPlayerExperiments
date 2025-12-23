//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import Foundation
import SwiftUI

extension VideoService {
    func addInterstitialVideoProgressObserver() {
        guard !interstitialVideoProgressObserverAdded else {
            print("Warning - addInterstitialVideoProgressObserver called more than once")
            return
        }
        self.interstitialVideoProgressObserver = interstitialVideoPlayer.addPeriodicTimeObserver(
            forInterval: .init(
                seconds: interstitialPlayerObservationFrequency,
                preferredTimescale: 600
            ),
            queue: .main
        ) { time in
            Task { @MainActor in
                if let currentPlayerItem = self.interstitialVideoPlayer.currentItem {
                    let totalDuration = currentPlayerItem.duration.seconds
                    let currentDuration = self.interstitialVideoPlayer.currentTime().seconds
                    let remaining = max(0, totalDuration - currentDuration)
                    let calculatedProgress = currentDuration / totalDuration
                    withAnimation(.linear(duration: self.interstitialPlayerObservationFrequency)) {
                        self.currentInterstitialVideoProgress = calculatedProgress
                        self.currentInterstitialVideoSecondsRemaining = remaining
                    }
                    if calculatedProgress == 1 {
                        self.interstitialVideoPlayerIsPlaying = false
                    }
                }
            }
        }
        interstitialVideoProgressObserverAdded = true
    }
    
    func removeInterstitialVideoProgressObserver() {
        guard let interstitialVideoProgressObserver else {
            print("Warning - removeInterstitialVideoProgressObserver called without an observer")
            return
        }
        interstitialVideoPlayer.removeTimeObserver(interstitialVideoProgressObserver)
        self.interstitialVideoProgressObserver = nil
        self.interstitialVideoProgressObserverAdded = false
    }
    
    func addContentVideoProgressObserver() {
        guard !contentVideoProgressObserverAdded else {
            print("Warning - addContentVideoProgressObserver called more than once")
            return
        }
        self.contentVideoProgressObserver = contentVideoPlayer.addPeriodicTimeObserver(
            forInterval: .init(
                seconds: contentPlayerObservationFrequency,
                preferredTimescale: 600
            ),
            queue: .main
        ) { time in
            Task { @MainActor in
                if let currentPlayerItem = self.contentVideoPlayer.currentItem {
                    let totalDuration = currentPlayerItem.duration.seconds
                    let currentDuration = self.contentVideoPlayer.currentTime().seconds
                    let calculatedProgress = currentDuration / totalDuration
                    withAnimation(.linear(duration: self.contentPlayerObservationFrequency)) {
                        self.currentContentVideoProgress = calculatedProgress
                    }
                    
                    if calculatedProgress == 1 {
                        self.contentVideoPlayerIsPlaying = false
                        
                    }
                }
            }
        }
        contentVideoProgressObserverAdded = true
    }
    
    func removeContentVideoProgressObserver() {
        guard let contentVideoProgressObserver else {
            print("Warning - removeContentVideoProgressObserver called without an observer")
            return
        }
        contentVideoPlayer.removeTimeObserver(contentVideoProgressObserver)
        self.contentVideoProgressObserver = nil
        self.contentVideoProgressObserverAdded = false
    }
}
