// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeutscheBahn",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DeutscheBahn",
            targets: ["DeutscheBahn"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/OpenParkingApp/Datasource.git", .upToNextMinor(from: "0.8.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DeutscheBahn",
            dependencies: ["Datasource"]),
        .testTarget(
            name: "DeutscheBahnTests",
            dependencies: [
                "DeutscheBahn",
                .product(name: "DatasourceValidation", package: "Datasource"),
            ]),
    ]
)
