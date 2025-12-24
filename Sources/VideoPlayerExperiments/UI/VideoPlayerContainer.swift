//
//  VideoPlayerContainer.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import SwiftUI
import AVKit

public struct VideoPlayerContainer: View {
    @State var service: VideoService = .initWithSamples()
    
    
    @Namespace var playerNamespace
    var horizontalPadding: CGFloat = 15
    var verticalPadding: CGFloat = 15
    @State var currentScrollOffset: CGFloat = 0
    @State var scrollDirection: ScrollDirection = .idle
    
    public init() {}
    
    public var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(service.playerItems) { playerItem in
                        Group {
                            switch playerItem {
                            case let .interstitial(meta): InterstitialVideoContainer(metadata: meta, namespace: playerNamespace)
                            case let .content(meta): ContentVideoContainer(metadata: meta, namespace: playerNamespace)
                            }
                        }
                        .environment(service)
                        .padding(.vertical, 5)
                        .containerRelativeFrame(.vertical, count: 1, spacing: 10, alignment: .center)
                        .scrollTransition(.animated.threshold(.centered)) { content, phase in
                            return content
                                .opacity(phase.isIdentity ? 1 : 0.5)
                        }
                    }
                }
                .ignoresSafeArea()
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $service.currentPlayerItemId, anchor: .center)
            .onChange(of: service.currentPlayerItemId, initial: true) { oldId, newId in
                handleVideoPlayerItemChange(hasPrevious: oldId != nil, isInitial: newId == nil, id: newId)
            }
            .scrollDisabled(service.interstitialVideoPlayerIsPlaying)
        }
    }
    
    @ViewBuilder
    var debugOverlay: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                HStack {
                    Text("currentScrollOffset")
                    Spacer()
                    Text("\(String(format: "%.2f", currentScrollOffset))")
                }
            }
            .frame(maxWidth: .infinity)
            VStack(alignment: .leading) {
                HStack {
                    Text("scrollDirection")
                    Spacer()
                    Text(scrollDirection.rawValue)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .font(.caption)
        .padding(10)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 10))
        .padding(.horizontal)
    }
    
    func handleVideoPlayerItemChange(hasPrevious: Bool = true, isInitial: Bool = false, id: UUID?) {
        guard let currentId = id ?? service.playerItems.first?.id else {
            print("No ID")
            return
        }
        service.stopAutoplay()
        let skipToNext = !isInitial && !hasPrevious
        if !skipToNext { service.loadVideoPlayerItem(for: currentId, settingAsCurrent: isInitial) }
        if !isInitial { service.startAutoplay(for: currentId) }
    }
    
    func setCurrentPlayerItem(_ id: UUID) {
        service.currentPlayerItemId = id
    }
}

#Preview {
    VideoPlayerContainer()
}
