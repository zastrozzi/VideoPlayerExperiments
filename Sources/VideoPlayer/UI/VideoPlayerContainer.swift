//
//  SwiftUIView.swift
//  VideoPlayer
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI
import AVKit

struct VideoPlayerContainer: View {
    @State var service: VideoService = .init()
    @Namespace var playerContainerNamespace
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(service.playerItems) { playerItem in
                    VStack {
                        Text(playerItem.title)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(playerItem.isInterstitial ? Color.green : Color.blue, in: .rect(cornerRadius: 16))
                    .overlay(alignment: .bottom) {
                        if service.isCurrentPlayerItem(playerItem.id) {
                            if playerItem.isInterstitial {
                                interstitialPlayerOverlay
                            } else {
                                videoPlayerOverlay
                            }
                        }
                    }
                    .padding()
                    .containerRelativeFrame([.horizontal])
                    .containerRelativeFrame(.vertical, count: 1, spacing: 20, alignment: .center)
                    .scrollTransition(.animated.threshold(.centered)) { content, phase in
                        switch phase {
                        case .identity:
                            Task { @MainActor in
                                service.currentPlayerItemId = playerItem.id
                                // service.startAutoplayForVideoPlayer...
                            }
                        case .bottomTrailing:
                            Task { @MainActor in
                                 service.preloadNextVideoPlayerItem(prevId: playerItem.id, direction: .reverse)
                                 service.loadVideoMetadataForNextItems(prevId: playerItem.id, count: 3, direction: .reverse)
                            }
                        case .topLeading:
                            Task { @MainActor in
                                 service.preloadNextVideoPlayerItem(prevId: playerItem.id, direction: .forward)
                                 service.loadVideoMetadataForNextItems(prevId: playerItem.id, count: 3, direction: .forward)
                            }
                        }
                        return content
                            .opacity(phase.isIdentity ? 1 : 0.2)
                    }
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .task {
            service.loadSampleItems()
        }
    }
    
    func setCurrentPlayerItem(_ id: UUID) {
        service.currentPlayerItemId = id
    }
    
    @ViewBuilder
    var videoPlayerOverlay: some View {
        VideoPlayer(player: service.videoPlayer)
            .clipShape(.rect(cornerRadius: 16))
            .matchedGeometryEffect(id: "videoPlayerOverlay", in: playerContainerNamespace)
    }
    
    @ViewBuilder
    var interstitialPlayerOverlay: some View {
        VideoPlayer(player: service.interstitialVideoPlayer)
            .clipShape(.rect(cornerRadius: 16))
            .matchedGeometryEffect(id: "interstitialPlayerOverlay", in: playerContainerNamespace)
            
    }
}

#Preview {
    VideoPlayerContainer()
}
