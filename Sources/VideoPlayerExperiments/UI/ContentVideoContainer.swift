//
//  ContentVideoContainer.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI

struct ContentVideoContainer: View {
    @Environment(VideoService.self) var videoService
    
    var metadata: ContentVideoMetadata
    
    init(metadata: ContentVideoMetadata) {
        self.metadata = metadata
    }
    
    var body: some View {
        @Bindable var videoService = videoService
        Group {
            if isCurrentPlayerItem {
                ContentVideoPlayer(player: $videoService.contentVideoPlayer)
                    .matchedGeometryEffect(id: "content", in: videoService.videoPlayerNamespace.wrappedValue)
            } else {
                Rectangle().fill(Material.thin)
            }
        }
        .transition(.opacity.animation(.easeInOut))
        .overlay {
            if !isCurrentPlayerItem {
                CacheableAsyncImage(url: metadata.thumbnailSource, transaction: .init(animation: .easeInOut)) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        Rectangle().fill(Material.thin)
                    }
                }
                .transition(.opacity.animation(.easeInOut))
            }
        }
        .overlay(alignment: .bottom) {
            VStack(spacing: 10) {
                ContentVideoInfo(metadata: metadata)
                ContentVideoScrubber(metadata: metadata)
            }
            .padding(.horizontal, 8)
            .padding(.vertical)
        }
        
        
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }

    
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
    
    
}

#Preview {
    @Previewable @State var videoService: VideoService = .initWithSamples()
    
    let metadata = videoService.playerItems
        .first(where: { item in
            !item.isInterstitial
        })!
        .asContent!
    
    return ContentVideoContainer(
        metadata: metadata
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
        videoService.startAutoplay(for: metadata.id)
    }
}
