// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Geoflash",
    products: [
        .library(
            name: "Geoflash",
            targets: ["Geoflash"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "Geoflash"),
        .testTarget(
            name: "GeoflashTests",
            dependencies: ["Geoflash"]),
    ]
)
