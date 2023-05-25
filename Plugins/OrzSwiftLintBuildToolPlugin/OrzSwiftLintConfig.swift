//
//  OrzSwiftLintConfig.swift
//  
//
//  Created by joker on 2023/5/25.
//
//  - [SwiftLint in Depth](https://www.kodeco.com/38422105-swiftlint-in-depth)
//  - [SwiftLint](https://swiftpackageindex.com/realm/SwiftLint)

import Foundation
import PackagePlugin

struct OrzSwiftLintConfig {

    let pluginWorkDirectory: Path

    func writeToPluginWorkDirectory() throws {
        try configYamlFormatContent.write(
            toFile: filePath.string,
            atomically: true,
            encoding: .utf8)
    }

    var filePath: PackagePlugin.Path {
        pluginWorkDirectory.appending(subpath: configName)
    }
    
    private let configName = "OrzSwiftLintConfig.yml"

    /// Reference
    /// [raywenderlich rules](https://github.com/kodecocodes/swift-style-guide/blob/main/com.raywenderlich.swiftlint.yml)
    private let configYamlFormatContent = """

opt_in_rules:
    - indentation_width

trailing_whitespace:
    ignores_empty_lines: true

vertical_whitespace:
    max_empty_lines: 2

indentation_width:
    indentation_width: 4

line_length:
  ignores_urls: true
  ignores_function_declarations: true
  ignores_comments: true

analyzer_rules:
  - unused_import

"""
}
