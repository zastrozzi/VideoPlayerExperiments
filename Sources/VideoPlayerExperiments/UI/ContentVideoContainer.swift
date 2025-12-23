//
//  ContentVideoContainer.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI

struct ContentVideoContainer: View {
    @Environment(VideoService.self) var videoService
    @Namespace private var videoInfoGlassNamespace
    
    @GestureState var isScrubberDragging: Bool = false
    @State private var isScrubberSeeking: Bool = false
    @State private var lastScrubberDragProgress: CGFloat = 0
    @State private var scrubberTimeout: DispatchWorkItem?
    @State private var showScrubberControls: Bool = true
    
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
                videoInfo
                videoScrubber
            }
            .padding(.horizontal, 8)
            .padding(.vertical)
        }
        
        
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
    }
    
    @ViewBuilder
    var videoInfo: some View {
        GlassEffectContainer {
            HStack {
                VStack(alignment: .leading) {
                    Text(metadata.title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .padding(.top, 10)
                        .padding(.leading, 12)
                        .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
                    
                    Text("Content")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.bottom, 10)
                        .padding(.leading, 12)
                        .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
                }
                
                Spacer()
                Button {
                    withAnimation {
                        videoService.toggleContentVideoPlayback(for: metadata.id)
                    }
                } label: {
                    Label(
                        "Play/Pause",
                        systemImage: (
                            isCurrentPlayerItem && videoService.contentVideoPlayerIsPlaying
                        ) ? "pause.circle" : "play.circle"
                    )
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .padding()
                }
                .buttonStyle(.plain)
                .contentShape(.circle)
                .glassEffect(.regular.interactive())
                .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
            }
            
        }
    }
    
    @ViewBuilder
    var videoScrubber: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .glassEffect()
            
            Rectangle()
                .fill(.yellow)
                .scaleEffect(
                    x: isCurrentPlayerItem ? videoService.currentContentVideoProgress : 0,
                    anchor: .leading
                )
            
        }
        .frame(height: 3)
        .overlay(alignment: .leading) {
            if isCurrentPlayerItem {
                GeometryReader { proxy in
                    Circle()
                        .fill(.yellow)
                        .frame(width: 15, height: 15)
                        .contentShape(Rectangle())
                        .offset(x: (proxy.size.width * videoService.currentContentVideoProgress) - 7.5)
                        .gesture(
                            DragGesture()
                                .updating($isScrubberDragging, body: { _, out, _ in
                                    out = true
                                })
                                .onChanged({ value in
                                    if let scrubberTimeout { scrubberTimeout.cancel() }
                                    let translationX: CGFloat = value.translation.width
                                    let calculatedProgress = (translationX / proxy.size.width) + lastScrubberDragProgress
                                    videoService.currentContentVideoProgress = max(min(calculatedProgress, 1), 0)
                                    isScrubberSeeking = true
                                })
                                .onEnded(
                                    { value in
                                        lastScrubberDragProgress = videoService.currentContentVideoProgress
                                        if let currentPlayerItem = videoService.contentVideoPlayer.currentItem {
                                            let totalDuration = currentPlayerItem.duration.seconds
                                            videoService.contentVideoPlayer.seek(
                                                to: .init(
                                                    seconds: totalDuration * videoService.currentContentVideoProgress,
                                                    preferredTimescale: 600
                                                )
                                            )
                                        if videoService.contentVideoPlayerIsPlaying {
                                            timeoutScrubberControls()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                            isScrubberSeeking = false
                                        }
                                    }
                                })
                        )
                }
                .frame(height: 15)
            }
        }
        .padding(.horizontal, 8)
    }
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
    
    func timeoutScrubberControls() {
        if let scrubberTimeout {
            scrubberTimeout.cancel()
        }
        
        scrubberTimeout = .init(block: {
            withAnimation(.easeInOut(duration: 0.35)) {
                showScrubberControls = false
            }
        })
        
        if let scrubberTimeout {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: scrubberTimeout)
        }
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
