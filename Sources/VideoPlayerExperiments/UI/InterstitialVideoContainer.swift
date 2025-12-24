//
//  SwiftUIView.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI

struct InterstitialVideoContainer: View {
    @Environment(VideoService.self) var videoService
    var namespace: Namespace.ID
    
    var metadata: InterstitialVideoMetadata
    var allowsPlaybackControl: Bool
    var playerStateAnimation: Animation = .smooth(duration: 0.8)
    
    init(metadata: InterstitialVideoMetadata, namespace: Namespace.ID, allowsPlaybackControl: Bool = false) {
        self.metadata = metadata
        self.allowsPlaybackControl = allowsPlaybackControl
        self.namespace = namespace
    }
    
    var body: some View {
        @Bindable var videoService = videoService
        ConcentricRectangle(corners: .concentric, isUniform: true).fill(Material.thin)
            .overlay {
                if isCurrentPlayerItem {
                    InterstitialVideoPlayer(player: $videoService.interstitialVideoPlayer)
                    // .matchedGeometryEffect(id: "video-player", in: namespace)
                }
            }
            .overlay {
                if !isCurrentPlayerItem {
                    CacheableAsyncImage(
                        url: metadata.thumbnailSource,
                        transaction: .init(
                            animation: playerStateAnimation
                        )
                    ) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else {
                            Rectangle().fill(Material.thin)
                        }
                    }
                }
            }
            .clipShape(.rect(corners: .concentric, isUniform: true))
            .overlay {
                
                ConcentricRectangle(corners: .concentric, isUniform: true)
                    .inset(amount: 2.5)
                    .trim(from: 0, to: videoService.currentInterstitialVideoProgress)
                    .stroke(Color.yellow.gradient, style: .init(lineWidth: 5, lineCap: .round, lineJoin: .round), antialiased: true)
                
            }
            .clipShape(.rect(corners: .concentric, isUniform: true))
            .overlay(alignment: .bottom) {
                if isCurrentPlayerItem {
                    VStack(spacing: 10) {
                        
                        InterstitialVideoInfo(metadata: metadata, allowsPlaybackControl: allowsPlaybackControl)
                            .matchedGeometryEffect(id: "video-info", in: namespace)
                    }
                    .padding(8)
                }
            }
            
            .padding(.horizontal, 10)
            .animation(playerStateAnimation, value: isCurrentPlayerItem)
            .shadow(radius: 10)
//            .ignoresSafeArea()
    }
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
}

#Preview {
    @Previewable @State var videoService: VideoService = .initWithSamples()
    @Previewable @State var namespace: Namespace = .init()
    let metadata = videoService.playerItems
        .first(where: { item in
            item.isInterstitial
        })!
        .asInterstitial!
    
    return InterstitialVideoContainer(
        metadata: metadata,
        namespace: namespace.wrappedValue,
        allowsPlaybackControl: true
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
        videoService.startAutoplay(for: metadata.id)
    }
}
