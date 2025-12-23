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
    
    return ContentVideoInfo(
        metadata: metadata
    )
    .environment(videoService)
    .task {
        videoService.loadVideoPlayerItem(for: metadata.id, settingAsCurrent: true)
        videoService.startAutoplay(for: metadata.id)
    }
}
