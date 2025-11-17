// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DFImageManager",
    platforms: [
        .iOS(.v8),
        .watchOS(.v2)
    ],
    products: [
        // Default product includes Core and UI
        .library(
            name: "DFImageManager",
            targets: ["DFImageManagerCore", "DFImageManagerUI"]
        ),
        // Individual products for each module
        .library(
            name: "DFImageManagerCore",
            targets: ["DFImageManagerCore"]
        ),
        .library(
            name: "DFImageManagerUI",
            targets: ["DFImageManagerUI"]
        ),
        .library(
            name: "DFImageManagerPhotosKit",
            targets: ["DFImageManagerPhotosKit"]
        ),
        .library(
            name: "DFImageManagerWebP",
            targets: ["DFImageManagerWebP"]
        ),
        .library(
            name: "DFImageManagerGIF",
            targets: ["DFImageManagerGIF"]
        ),
        .library(
            name: "DFImageManagerAFNetworking",
            targets: ["DFImageManagerAFNetworking"]
        ),
    ],
    dependencies: [
        // External dependencies
        .package(url: "https://github.com/AFNetworking/AFNetworking.git", from: "4.0.0"),
        .package(url: "https://github.com/Flipboard/FLAnimatedImage.git", from: "1.0.0"),
    ],
    targets: [
        // C library for WebP
        .target(
            name: "libwebp",
            path: "Pod/libwebp",
            sources: ["src"],
            publicHeadersPath: "src/webp",
            cSettings: [
                .headerSearchPath("src"),
                .define("WEBP_USE_THREAD"),
            ]
        ),

        // Core target
        .target(
            name: "DFImageManagerCore",
            path: "Pod/Source/Core",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("Managing"),
                .headerSearchPath("Processing"),
                .headerSearchPath("Support"),
                .headerSearchPath("Caching"),
                .headerSearchPath("Protocols"),
                .headerSearchPath("Private"),
                .headerSearchPath("Fetching"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .watchOS])),
            ]
        ),

        // UI target
        .target(
            name: "DFImageManagerUI",
            dependencies: ["DFImageManagerCore"],
            path: "Pod/Source/UI",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Core"),
                .headerSearchPath("../Core/Managing"),
                .headerSearchPath("../Core/Processing"),
                .headerSearchPath("../Core/Support"),
                .headerSearchPath("../Core/Caching"),
                .headerSearchPath("../Core/Protocols"),
                .headerSearchPath("../Core/Private"),
                .headerSearchPath("../Core/Fetching"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        ),

        // PhotosKit target
        .target(
            name: "DFImageManagerPhotosKit",
            dependencies: ["DFImageManagerCore"],
            path: "Pod/Source/PhotosKit",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Core"),
                .headerSearchPath("../Core/Managing"),
                .headerSearchPath("../Core/Processing"),
                .headerSearchPath("../Core/Support"),
                .headerSearchPath("../Core/Protocols"),
                .define("DF_SUBSPEC_PHOTOSKIT_ENABLED", to: "1"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
                .linkedFramework("Photos", .when(platforms: [.iOS])),
            ]
        ),

        // WebP target
        .target(
            name: "DFImageManagerWebP",
            dependencies: ["DFImageManagerCore", "libwebp"],
            path: "Pod/Source/WebP",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Core"),
                .headerSearchPath("../Core/Processing"),
                .headerSearchPath("../Core/Protocols"),
                .define("DF_SUBSPEC_WEBP_ENABLED", to: "1"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        ),

        // GIF target (depends on FLAnimatedImage)
        .target(
            name: "DFImageManagerGIF",
            dependencies: [
                "DFImageManagerCore",
                "DFImageManagerUI",
                .product(name: "FLAnimatedImage", package: "FLAnimatedImage"),
            ],
            path: "Pod/Source/GIF",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Core"),
                .headerSearchPath("../Core/Managing"),
                .headerSearchPath("../Core/Protocols"),
                .headerSearchPath("../UI"),
                .define("DF_SUBSPEC_GIF_ENABLED", to: "1"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        ),

        // AFNetworking target
        .target(
            name: "DFImageManagerAFNetworking",
            dependencies: [
                "DFImageManagerCore",
                .product(name: "AFNetworking", package: "AFNetworking"),
            ],
            path: "Pod/Source/AFNetworking",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("."),
                .headerSearchPath("../Core"),
                .headerSearchPath("../Core/Managing"),
                .headerSearchPath("../Core/Protocols"),
                .headerSearchPath("../Core/Fetching"),
                .define("DF_SUBSPEC_AFNETWORKING_ENABLED", to: "1"),
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS])),
            ]
        ),
    ]
)
