//
//  SwiftUIView.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import SwiftUI

struct ContentVideoInfo: View {
    @Environment(VideoService.self) var videoService
    @Namespace private var videoInfoGlassNamespace
    
    var metadata: ContentVideoMetadata
    
    
    
    init(metadata: ContentVideoMetadata) {
        self.metadata = metadata
    }
    
    var body: some View {
        var verticalPadding: CGFloat = 12
        var horizontalPadding: CGFloat = 16
        var cornerRadius: CGFloat = 18
        
        GlassEffectContainer {
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    Text(metadata.title)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.primary)
//                        .padding(.top, verticalPadding)
//                        .padding(.leading, horizontalPadding)

                    
                    Text(videoTimeDisplay)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
//                        .padding(.bottom, verticalPadding)
//                        .padding(.leading, horizontalPadding)
                        
                }
                .safeAreaPadding(.leading, horizontalPadding)
                .safeAreaPadding(.vertical, verticalPadding)
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
                .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
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
                    .font(.title)
                }
                .buttonStyle(.plain)
                .contentShape(.circle)
                .safeAreaPadding(.trailing, horizontalPadding)
                .safeAreaPadding(.vertical, verticalPadding)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
                .glassEffectUnion(id: 1, namespace: videoInfoGlassNamespace)
            }
        }
    }
    
    var isCurrentPlayerItem: Bool {
        videoService.currentPlayerItemId == metadata.id
    }
    
    var videoTimeDisplay: String {
        guard isCurrentPlayerItem else { return "-:--/-:--"}
        func formatMMSS(_ seconds: Double) -> String {
            let totalSeconds = max(0, Int(seconds.rounded(.down)))
            let minutes = totalSeconds / 60
            let remainingSeconds = totalSeconds % 60
            
            return String(format: "%d:%02d", minutes, remainingSeconds)
        }
        let elapsedSeconds = videoService.currentContentVideoTotalSeconds * videoService.currentContentVideoProgress
        let elapsed = formatMMSS(elapsedSeconds)
        let total = formatMMSS(videoService.currentContentVideoTotalSeconds)
        return "\(elapsed) / \(total)"
//        return total
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
