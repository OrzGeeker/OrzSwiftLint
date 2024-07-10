// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzSwiftLint",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .plugin(
            name: "OrzSwiftLintBuildToolPlugin",
            targets: ["OrzSwiftLintBuildToolPlugin"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.55.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OrzSwiftLint",
            plugins: [
                .plugin(name: "OrzSwiftLintBuildToolPlugin")
            ]
        ),
        .plugin(
            name: "OrzSwiftLintBuildToolPlugin",
            capability: .buildTool(),
            dependencies: [
                .product(name: "swiftlint", package: "SwiftLint"),
            ]
        ),
        .plugin(
            name: "OrzSwiftLintCommandPlugin",
            capability: .command(
                intent: .custom(
                    verb: "swiftlint fix",
                    description: "format swift code with swiftlint"),
                permissions: [
                    .writeToPackageDirectory(reason: "format swift source file with swiftlint")
                ]
            )
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
