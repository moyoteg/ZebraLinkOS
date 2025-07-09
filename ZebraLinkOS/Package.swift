// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ZebraLinkOS",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "ZebraLinkOS",
            targets: ["ZebraLinkOS"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "ZebraLinkOS",
            path: "ZSDK_API.xcframework"
        )
    ]
)
