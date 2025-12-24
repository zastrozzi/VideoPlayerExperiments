//
//  InterstitialVideoInfo.swift
//  
//
//  Created by Jonathan Forbes on 24/12/2025.
//

import SwiftUI

struct InterstitialVideoInfo: View {
    @Environment(VideoService.self) var videoService
    @Namespace private var videoInfoGlassNamespace
    
    var metadata: InterstitialVideoMetadata
    var allowsPlaybackControl: Bool
    
    
    init(metadata: InterstitialVideoMetadata, allowsPlaybackControl: Bool = false) {
        self.metadata = metadata
        self.allowsPlaybackControl = allowsPlaybackControl
    }
    
    var body: some View {
        var verticalPadding: CGFloat = 12
        var horizontalPadding: CGFloat = 16
        var cornerRadius: CGFloat = 20
        
        GlassEffectContainer {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(metadata.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text("Sponsored")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .safeAreaPadding(.leading, horizontalPadding)
                .safeAreaPadding(.vertical, verticalPadding)
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
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
                        .font(.title)
                    }
                    .buttonStyle(.plain)
                    .contentShape(.circle)
                    .safeAreaPadding(.trailing, horizontalPadding)
                    .safeAreaPadding(.vertical, verticalPadding)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
                    .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
                }
                
                Text(secondsRemaining)
                    .font(.headline)
                    .safeAreaPadding(.trailing, horizontalPadding)
                    .safeAreaPadding(.vertical, verticalPadding)
                    .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                    .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
            }
        }
//        .clipShape(.rect(corners: .concentric, isUniform: true))
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
            !item.isInterstitial
        })!
        .asContent!
    
    return ContentVideoInfo(
        metadata: metadata
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
        //        videoService.startAutoplay(for: metadata.id)
    }
}
