//
//  SwiftUIView.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import SwiftUI

struct ContentVideoScrubber: View {
    @Environment(VideoService.self) var videoService
    @GestureState var isScrubberDragging: Bool = false
    @State private var isScrubberSeeking: Bool = false
    @State private var lastScrubberDragProgress: CGFloat = 0
    @State private var scrubberTimeout: DispatchWorkItem?
    @State private var showScrubberControls: Bool = false
    
    var metadata: ContentVideoMetadata
    
    init(metadata: ContentVideoMetadata) {
        self.metadata = metadata
    }
    
    var body: some View {
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
                        .frame(width: 20, height: 20)
                        .glassEffect(.regular.tint(.yellow), in: .circle)
                        .scaleEffect(
                            shouldScaleDown ? 0.001 : 1
                        )
                        .frame(width: 50, height: 50)
                        .contentShape(Rectangle())
                        
                        .offset(x: (proxy.size.width * videoService.currentContentVideoProgress) - 8.5, y: -8.5)
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
                        .frame(width: 20, height: 20)
                }
                
                .animation(.easeInOut(duration: 0.2), value: shouldScaleDown)
            }
        }
        .padding(.horizontal, 8)
    }
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
    
    var shouldScaleDown: Bool {
        !isScrubberDragging && !isScrubberSeeking && !showScrubberControls
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
    
    return ContentVideoScrubber(
        metadata: metadata
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
//        videoService.startAutoplay(for: metadata.id)
    }
}
