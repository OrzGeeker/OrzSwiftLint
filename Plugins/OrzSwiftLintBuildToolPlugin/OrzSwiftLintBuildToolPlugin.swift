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
        return [
            .buildCommand(
                displayName: "Lint Target: \(target.name)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: ["lint", "--no-cache", target.directory]
            )
        ]
    }
}

extension String {
    func log() {
        print("[Build Tool]: \(self)")
    }
}
