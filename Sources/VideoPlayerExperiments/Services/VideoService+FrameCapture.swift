//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 23/12/2025.
//

import Foundation
import AVKit

extension VideoService {
    @MainActor
    func captureFrame(
        from player: AVPlayer,
        at time: CMTime
    ) async throws -> CGImage {
        guard let item = player.currentItem else { throw NSError(domain: "Player has no item to capture from", code: -1) }
        
        let generator = AVAssetImageGenerator(asset: item.asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero
        
        return try await withCheckedThrowingContinuation { continuation in
            generator.generateCGImagesAsynchronously(
                forTimes: [NSValue(time: time)]
            ) { _, image, _, result, error in
                if let image {
                    continuation.resume(returning: image)
                } else {
                    continuation.resume(throwing: error ?? NSError(domain: "Capture frame failed", code: -1))
                }
            }
        }
    }
}
