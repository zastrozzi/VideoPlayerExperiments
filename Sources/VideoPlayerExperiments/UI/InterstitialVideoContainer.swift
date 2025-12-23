//
//  SwiftUIView.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI

struct InterstitialVideoContainer: View {
    @Environment(VideoService.self) var videoService
    @Namespace private var videoInfoGlassNamespace
    
    var metadata: InterstitialVideoMetadata
    var allowsPlaybackControl: Bool
    
    init(metadata: InterstitialVideoMetadata, allowsPlaybackControl: Bool = false) {
        self.metadata = metadata
        self.allowsPlaybackControl = allowsPlaybackControl
    }
    
    var body: some View {
        @Bindable var videoService = videoService
        Group {
            if isCurrentPlayerItem {
                InterstitialVideoPlayer(player: $videoService.interstitialVideoPlayer)
            } else {
                RoundedRectangle(cornerRadius: 16)
            }
        }
        .matchedGeometryEffect(id: "interstitial", in: videoService.videoPlayerNamespace.wrappedValue)
        .overlay(alignment: .bottom) {
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
                        
                        Text("Sponsored")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.bottom, 10)
                            .padding(.leading, 12)
                            .glassEffect(.regular, in: .rect(cornerRadius: 14))
                            .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
                    }
                    
                    Spacer()
                    if allowsPlaybackControl {
                        Button {
                            withAnimation {
                                videoService.toggleInterstitialVideoPlayback(for: metadata.id)
                            }
                        } label: {
                            Label(
                                "Play/Pause",
                                systemImage: isCurrentPlayerItem && videoService.interstitialVideoPlayerIsPlaying ? "pause.circle" : "play.circle"
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
                    Text(secondsRemaining)
                        .font(.headline)
                        .frame(width: 30)
                        .padding(.trailing, 12)
                        .glassEffect(.regular, in: .rect(cornerRadius: 14))
                        .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
                }
            }
            .padding(8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 19, style: .continuous)
                .trim(from: 0, to: videoService.currentInterstitialVideoProgress)
                .stroke(Color.yellow, style: .init(lineWidth: 10, lineCap: .round, lineJoin: .round), antialiased: true)
                
        }
        .clipShape(.rect(cornerRadius: 16, style: .continuous))
        .padding(.horizontal)
            
    }
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
    
    var secondsRemaining: String {
        guard isCurrentPlayerItem else { return "\u{00a0}" }
        let value = videoService.currentInterstitialVideoSecondsRemaining
        if value == .zero { return "\u{00a0}" }
        return String(format: "%.0f", value)
    }
    
}

#Preview {
    @Previewable @State var videoService: VideoService = .initWithSamples()
    
    let metadata = videoService.playerItems
        .first(where: { item in
            item.isInterstitial
        })!
        .asInterstitial!
    
    return InterstitialVideoContainer(
        metadata: metadata,
        allowsPlaybackControl: true
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
        videoService.startAutoplay(for: metadata.id)
    }
}
