//
//  VideoPlayerContainer.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI
import AVKit

struct VideoPlayerContainer: View {
    @State var service: VideoService = .initWithSamples()
    @Namespace var playerContainerNamespace
    
//    @State private var activeVideoPlayerItem: VideoPlayerItem.ID?
    
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 15
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(service.playerItems) { playerItem in
                    Group {
                        switch playerItem {
                        case let .interstitial(meta): InterstitialVideoContainer(metadata: meta)
                        case let .content(meta): ContentVideoContainer(metadata: meta)
                                
                        }
                    }
                    .environment(service)
                    .padding(.vertical, verticalPadding)
                    .containerRelativeFrame(.vertical, count: 1, spacing: verticalPadding, alignment: .center)

                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .scrollPosition(id: $service.currentPlayerItemId, anchor: .center)
        .onChange(of: service.currentPlayerItemId, initial: true) { oldId, newId in
            handleVideoPlayerItemChange(id: newId)
        }
        .scrollDisabled(service.interstitialVideoPlayerIsPlaying)
        
    }
    
    func handleVideoPlayerItemChange(id: UUID?) {
        guard let currentId = id ?? service.playerItems.first?.id else {
            print("No ID")
            return
        }
        service.stopAutoplay()
        service.loadVideoPlayerItem(for: currentId, settingAsCurrent: id == nil)
        service.startAutoplay(for: currentId)
    }
    
    func setCurrentPlayerItem(_ id: UUID) {
        service.currentPlayerItemId = id
    }
}

#Preview {
    VideoPlayerContainer()
}
