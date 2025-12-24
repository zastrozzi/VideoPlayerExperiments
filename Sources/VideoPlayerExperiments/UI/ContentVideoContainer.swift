//
//  ContentVideoContainer.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI

struct ContentVideoContainer: View {
    @Environment(VideoService.self) var videoService
    
    var namespace: Namespace.ID
    var metadata: ContentVideoMetadata
    var playerStateAnimation: Animation = .smooth(duration: 0.8)
    
    init(metadata: ContentVideoMetadata, namespace: Namespace.ID) {
        self.metadata = metadata
        self.namespace = namespace
    }
    
    var body: some View {
        @Bindable var videoService = videoService
        ConcentricRectangle(corners: .concentric, isUniform: true).fill(Material.thin)
            .overlay {
                if isCurrentPlayerItem {
                    ContentVideoPlayer(player: $videoService.contentVideoPlayer)
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
            .overlay(alignment: .bottom) {
                if isCurrentPlayerItem {
                    VStack(spacing: 10) {
                        ContentVideoScrubber(metadata: metadata)
                            .matchedGeometryEffect(id: "video-scrubber", in: namespace)
                        ContentVideoInfo(metadata: metadata)
                            .matchedGeometryEffect(id: "video-info", in: namespace)
                        
                    }
                    .padding(8)
//                    .padding(.vertical)
                }
            }
            .animation(playerStateAnimation, value: isCurrentPlayerItem)
            .padding(.horizontal, 10)
            .shadow(radius: 10)
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
            !item.isInterstitial
        })!
        .asContent!
    
    return ContentVideoContainer(
        metadata: metadata,
        namespace: namespace.wrappedValue
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
//        videoService.startAutoplay(for: metadata.id)
    }
}
