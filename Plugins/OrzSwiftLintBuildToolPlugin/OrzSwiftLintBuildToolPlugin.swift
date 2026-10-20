//
//  OrzSwiftLintBuildToolPlugin.swift
//
//
//  Created by joker on 2023/5/23.
//

import Foundation
import PackagePlugin

@main
struct OrzSwiftLintBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: any Target) async throws -> [Command] {
        // Windows：SwiftLint 的 artifactbundle 没有 Windows 产物（SwiftPM 会报
        // "Tool 'swiftlint' is not supported on the target platform"），且插件失败会中止整个构建。
        #if os(Windows)
        return []
        #endif

        // 逃生阀（2026-10-20）：SwiftLint 的**预编译二进制**对 glibc 有硬性下限（当前 artifactbundle
        // 要求 GLIBC_2.38 / GLIBCXX_3.4.32），在老的发行版上根本起不来，而插件失败会中止整个构建 ——
        // 于是「在 Ubuntu 22.04 上构建以降低产物 glibc 下限」被 lint 工具自己挡住了。
        // 发布流水线（OrzMCKit release.yml 的 build-linux）用它构建**产物**；lint 仍在 CI 里跑，不会漏。
        if ProcessInfo.processInfo.environment["ORZSWIFTLINT_SKIP"] == "1" {
            return []
        }

        guard let swiftTarget = target as? SwiftSourceModuleTarget
        else {
            return []
        }
        return try buildCommands(
            targetName: swiftTarget.name,
            targetDirectoryURL: swiftTarget.directoryURL,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL,
            toolURL: try context.tool(named: "swiftlint").url
        )
    }
}

extension OrzSwiftLintBuildToolPlugin {
    func buildCommands(
        targetName: String,
        targetDirectoryURL: URL,
        pluginWorkDirectoryURL: URL,
        toolURL: URL
    ) throws -> [Command] {
        let config = OrzSwiftLintConfig(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
        try config.writeToPluginWorkDirectory()
        let args: [String] = [
            "lint",
            "--no-cache",
            "--config",
            config.fileURL.path(),
            targetDirectoryURL.path()
        ]
        return [.buildCommand(displayName: "Lint Target: \(targetName)", executable: toolURL, arguments: args)]
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
extension OrzSwiftLintBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let pluginWorkDirectoryURL = URL(filePath: NSTemporaryDirectory())
        return try buildCommands(
            targetName: target.displayName,
            targetDirectoryURL: context.xcodeProject.directoryURL,
            pluginWorkDirectoryURL: pluginWorkDirectoryURL,
            toolURL: try context.tool(named: "swiftlint").url
        )
    }
}
#endif
