//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import Foundation

extension VideoService {
    public func loadSampleItems() {
        self.playerItems = .init(VideoPlayerSamples.videoPlayerItems)
    }
    
    public static func initWithSamples() -> VideoService {
        let service = VideoService()
        service.loadSampleItems()
        return service
    }
}
