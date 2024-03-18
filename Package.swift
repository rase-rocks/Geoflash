// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "Geoflash",
    products: [
        .library(
            name: "Geoflash",
            targets: ["Geoflash"]),
    ],
    targets: [
        .target(
            name: "Geoflash"),
        .testTarget(
            name: "GeoflashTests",
            dependencies: ["Geoflash"]),
    ]
)
