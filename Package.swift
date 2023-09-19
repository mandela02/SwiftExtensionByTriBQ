// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftExtensionTriBQ",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]),
        .library(
            name: "PhoneHelper",
            targets: ["PhoneHelper"]),
        .library(
            name: "UnderlyingViewForSwiftUI",
            targets: ["UnderlyingViewForSwiftUI"]),
        .library(
            name: "SwiftUtilities",
            targets: ["SwiftUtilities"]),
        .library(
            name: "ViewExtensionForSwiftUI",
            targets: ["ViewExtensionForSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git",
            .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit",
            .upToNextMajor(from: "3.4.0")),
        .package(url: "https://github.com/airbnb/lottie-spm.git",
            .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/kean/Nuke.git",
            .upToNextMajor(from: "11.0.0")),
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                .byName(name: "Alamofire"),
            ]
        ),
        .target(
            name: "PhoneHelper",
            dependencies: [
                .byName(name: "PhoneNumberKit"),
            ]
        ),
        .target(
            name: "UnderlyingViewForSwiftUI",
            dependencies: [
                .product(name: "Lottie", package: "lottie-spm")
            ]
        ),
        .target(name: "SwiftUtilities"),
        .target(
            name: "ViewExtensionForSwiftUI",
            dependencies: [
                .product(name: "NukeUI", package: "Nuke")
            ]
        ),
    ]
)
