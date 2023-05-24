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

        print(target.moduleName)
        return try target.sourceFiles(withSuffix: ".swift").map { sourceFile in
            return .buildCommand(
                displayName: "format file: \(sourceFile)",
                executable: try context.tool(named: "swiftlint").path,
                arguments: [],
                inputFiles: [sourceFile.path],
                outputFiles: [sourceFile.path]
            )
        }
    }
}
