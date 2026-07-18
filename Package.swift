// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DFImageManager",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "DFImageManager",
            targets: ["DFImageManager"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/libwebp-Xcode.git", exact: "1.3.2")
    ],
    targets: [
        .target(
            name: "DFImageManager",
            dependencies: [
                .product(name: "libwebp", package: "libwebp-Xcode")
            ],
            path: "Pod/Source",
            exclude: [
                "AFNetworking",
                "GIF",
                "PhotosKit"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include/DFImageManager"),
                .headerSearchPath("Core/Private"),
                .define("DF_SUBSPEC_WEBP_ENABLED", to: "1")
            ]
        )
    ]
)
