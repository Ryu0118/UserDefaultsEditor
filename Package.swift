// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserDefaultsEditor",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "UserDefaultsEditor",
            targets: ["UserDefaultsEditor"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/p-x9/EditValueView.git", from: "0.6.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "UserDefaultsEditor",
            dependencies: [
                .product(name: "EditValueView", package: "EditValueView")
            ],
            resources: [.copy("PrivacyInfo.xcprivacy")]
        ),
        .testTarget(
            name: "UserDefaultsEditorTests",
            dependencies: ["UserDefaultsEditor"]
        ),
    ]
)
