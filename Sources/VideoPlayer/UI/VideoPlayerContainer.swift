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
    
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 15
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(service.playerItems) { playerItem in
                    Group {
                        switch playerItem {
                        case let .interstitial(meta): interstitialPlayerItem(meta)
                        case let .video(meta): videoPlayerItem(meta)
                        }
                    }
                    .padding(horizontalPadding)
//                    .containerRelativeFrame([.horizontal])
                    .containerRelativeFrame(.vertical, count: 1, spacing: 20, alignment: .center)
                    .scrollTransition(.animated.threshold(.centered)) { content, phase in
                        switch phase {
                        case .identity:
                            Task { @MainActor in
                                service.stopAutoplay(for: playerItem.id)
                                service.loadVideoPlayerItem(for: playerItem.id)
                                service.startAutoplay(for: playerItem.id)
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
                            .opacity(phase.isIdentity ? 1 : 0.8)
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
    var videoPlayer: some View {
        VideoPlayer(player: service.videoPlayer)
            .aspectRatio(contentMode: .fill)
            .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
                if axis == .vertical {
                    return length - (verticalPadding * 2)
                }
                if axis == .horizontal {
                    return length - (horizontalPadding * 2)
                }
                else {
                    return length
                }
            }
            .clipShape(.rect(cornerRadius: 16))
            .matchedGeometryEffect(id: "videoPlayer", in: playerContainerNamespace)
            .onAppear {
                service.videoPlayer.pause()
            }
    }
    
    @ViewBuilder
    var interstitialPlayer: some View {
        VideoPlayer(player: service.interstitialVideoPlayer)
            .aspectRatio(contentMode: .fill)
            .containerRelativeFrame([.horizontal, .vertical]) { length, axis in
                if axis == .vertical {
                    return length - (verticalPadding * 2)
                }
                if axis == .horizontal {
                    return length - (horizontalPadding * 2)
                }
                else {
                    return length
                }
            }
            .clipShape(.rect(cornerRadius: 16))
            .matchedGeometryEffect(id: "interstitialPlayer", in: playerContainerNamespace)
            .onAppear {
                service.interstitialVideoPlayer.pause()
            }
    }
    
    @ViewBuilder
    func videoPlayerItem(_ metadata: VideoMetadata) -> some View {
        ZStack {
            CacheableAsyncImage(url: metadata.thumbnailSource, transaction: .init(animation: .easeInOut)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Rectangle().fill(Material.thin)
                }
            }
            .scaledToFill()
            .containerRelativeFrame(.horizontal) { length, axis in
                return length - (horizontalPadding * 2)
            }
            
            if service.isCurrentPlayerItem(metadata.id) {
                videoPlayer
                    .allowsHitTesting(false)
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue)
        .clipShape(.rect(cornerRadius: 16))
        .onTapGesture {
            service.toggleVideoPlayback()
        }
    }
    
    @ViewBuilder
    func interstitialPlayerItem(_ metadata: InterstitialVideoMetadata) -> some View {
        ZStack {
            CacheableAsyncImage(url: metadata.thumbnailSource, transaction: .init(animation: .easeInOut)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    Rectangle().fill(Material.thin)
                }
            }
            .scaledToFill()
            .containerRelativeFrame(.horizontal) { length, axis in
                return length - (horizontalPadding * 2)
            }
            
            if service.isCurrentPlayerItem(metadata.id) {
                interstitialPlayer
                    .allowsHitTesting(false)
                    .transition(.opacity.animation(.easeInOut))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green)
        .clipShape(.rect(cornerRadius: 16))
        .onTapGesture {
            service.toggleInterstitialVideoPlayback()
        }
    }
}

#Preview {
    VideoPlayerContainer()
}
