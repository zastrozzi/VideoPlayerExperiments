//
//  File.swift
//  VideoPlayerExperiments
//
//  Created by Jonathan Forbes on 22/12/2025.
//

import Foundation

extension VideoPlayerSamples {
    public static var videoPlayerItems: [VideoPlayerItem] {
        [
            .content(
                meta: .init(
                    title: "Big Buck Bunny",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
                )
            ),
            .content(
                meta: .init(
                    title: "Elephant Dream",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "Sintel",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/Sintel.jpg")!
                )
            ),
            
            .interstitial(
                meta: .init(
                    title: "For Bigger Escapes",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerEscapes.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "For Bigger Fun",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerFun.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "For Bigger Joyrides",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "For Bigger Meltdowns",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg")!
                )
            ),
            .interstitial(
                meta: .init(
                    title: "For Bigger Blazes",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "Subara Outback on Street and Dirt",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/SubaruOutbackOnStreetAndDirt.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "Tears of Steel",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/TearsOfSteel.jpg")!
                )
            ),
            .content(
                meta: .init(
                    title: "Volkswagen GTI Review",
                    source: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4")!,
                    thumbnailSource: .init(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/VolkswagenGTIReview.jpg")!
                )
            )
        ]
    }
}
