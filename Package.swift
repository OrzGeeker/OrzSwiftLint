// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OrzSwiftLint",
    platforms: [
        .macOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .plugin(
            name: "OrzSwiftLintBuildToolPlugin",
            targets: ["OrzSwiftLintBuildToolPlugin"]
        )
    ],
    dependencies: [],
    targets: [
        // SwiftLint 官方预编译可执行（artifactbundle，含 macos/linux 三平台）。
        // 用它替代「从源码编译 SwiftLint/swift-syntax」：插件依旧每次构建都跑 lint，
        // 但不再有 swift-syntax 编译开销（下游冷编实测 554s→~几十秒，缓存从 ~3GiB→~百MB）。
        // 升级：换 0.6x 的 url 并同步 checksum（= SwiftLintBinary.artifactbundle.zip 的 sha256）。
        .binaryTarget(
            name: "swiftlint",
            url: "https://github.com/realm/SwiftLint/releases/download/0.65.1/SwiftLintBinary.artifactbundle.zip",
            checksum: "c3a1d77647ca18c1b7e9be7dbc6cd4490d26422f28814b76370244ff61970869"
        ),
        .target(
            name: "OrzSwiftLint",
            plugins: [
                .plugin(name: "OrzSwiftLintBuildToolPlugin")
            ]
        ),
        .plugin(
            name: "OrzSwiftLintBuildToolPlugin",
            capability: .buildTool(),
            dependencies: ["swiftlint"]
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
    ]
)
