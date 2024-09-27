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
        guard let pluginWorkDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask).first
        else {
            return []
        }
        return try buildCommands(
            targetName: target.displayName,
            targetDirectoryURL: context.xcodeProject.directoryURL,
            pluginWorkDirectoryURL: pluginWorkDirectoryURL,
            toolURL: try context.tool(named: "swiftlint").url
        )
    }
}
#endif
