//
//  OrzSwiftLintBuildToolPlugin.swift
//  
//
//  Created by joker on 2023/5/23.
//

import PackagePlugin

@main
struct OrzSwiftLintBuildToolPlugin: BuildToolPlugin {

    func createBuildCommands(
        context: PackagePlugin.PluginContext,
        target: PackagePlugin.Target
    ) async throws -> [PackagePlugin.Command] {

        guard let target = target as? SourceModuleTarget
        else {
            return []
        }

        let config = OrzSwiftLintConfig(context: context)
        
        try config.writeToPluginWorkDirectory()

        var args: [CustomStringConvertible] = [
            "lint",
            "--no-cache",
            "--config",
            config.filePath,
            target.directory
        ]

        return [
            .buildCommand(
                displayName: "Lint Target: \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: args
            )
        ]
    }
}
