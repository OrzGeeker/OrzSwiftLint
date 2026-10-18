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
        #if os(Windows)
        // SwiftLint 的 artifactbundle 没有 Windows 产物（SwiftPM 会直接报
        // "Tool 'swiftlint' is not supported on the target platform"），
        // 且插件失败会让整个构建中止。Windows 上直接跳过 lint（D14 Phase 6.5）。
        return []
        #else
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
        #endif
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
