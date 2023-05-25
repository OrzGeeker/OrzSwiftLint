//
//  OrzSwiftLintBuildToolPlugin.swift
//  
//
//  Created by joker on 2023/5/23.
//

import PackagePlugin

@main
struct OrzSwiftLintBuildToolPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {

        guard let target = target as? SourceModuleTarget
        else {
            return []
        }

        return try buildCommands(
            targetName: target.name,
            targetDirectory: target.directory,
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint").path
        )
    }
}

#if canImport(XcodeProjectPlugin)
import XcodeProjectPlugin
extension OrzSwiftLintBuildToolPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        return try buildCommands(
            targetName: target.displayName,
            targetDirectory: context.xcodeProject.directory,
            pluginWorkDirectory: context.pluginWorkDirectory,
            tool: try context.tool(named: "swiftlint").path
        )
    }
}

#endif
extension OrzSwiftLintBuildToolPlugin {
    func buildCommands(
        targetName: String,
        targetDirectory: Path,
        pluginWorkDirectory: Path,
        tool: Path
    ) throws -> [PackagePlugin.Command] {

        let config = OrzSwiftLintConfig(pluginWorkDirectory: pluginWorkDirectory)

        try config.writeToPluginWorkDirectory()

        let args: [CustomStringConvertible] = [
            "lint",
            "--no-cache",
            "--config",
            config.filePath,
            targetDirectory
        ]

        return [
            .buildCommand(
                displayName: "Lint Target: \(targetName)",
                executable: tool,
                arguments: args
            )
        ]
    }
}


