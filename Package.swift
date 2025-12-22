// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VideoPlayerExperiments",
    platforms: [
        .iOS(.v26)
    ],
    
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "VideoPlayerExperiments",
            targets: ["VideoPlayerExperiments"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.2.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "VideoPlayerExperiments",
            dependencies: [
                .product(name: "Collections", package: "swift-collections")
            ],
            path: "Sources/VideoPlayerExperiments"
        ),
        .testTarget(
            name: "VideoPlayerExperimentsTests",
            dependencies: ["VideoPlayerExperiments"],
            path: "Tests/VideoPlayerExperimentsTests"
        ),
    ]
)
