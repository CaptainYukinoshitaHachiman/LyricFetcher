// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LyricFetcher",
    dependencies: [
    .package(url: "https://github.com/AlwaysRightInstitute/Shell.git", from: "0.1.0"),
	.package(url: "https://github.com/kylef/Commander.git", from: "0.8.0")
    ],
    targets: [
        .target(
            name: "LyricFetcher",
			dependencies: ["Shell", "Commander"]),
        .testTarget(
            name: "LyricFetcherTests",
            dependencies: ["LyricFetcher"]),
    ]
)
