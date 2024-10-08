//
//  OrzSwiftLintConfig.swift
//
//
//  Created by joker on 2023/5/25.
//
//  - [SwiftLint in Depth](https://www.kodeco.com/38422105-swiftlint-in-depth)
//  - [SwiftLint](https://github.com/realm/SwiftLint)
//  - [SwiftLintDoc](https://realm.github.io/SwiftLint/)
//  - [raywenderlich rules](https://github.com/kodecocodes/swift-style-guide/blob/main/com.raywenderlich.swiftlint.yml)

import Foundation
import PackagePlugin

struct OrzSwiftLintConfig {
    
    let pluginWorkDirectoryURL: URL
    
    func writeToPluginWorkDirectory() throws {
        try configYamlFormatContent.write(
            to: fileURL,
            atomically: true,
            encoding: .utf8)
    }
    
    var fileURL: URL {
        pluginWorkDirectoryURL.appending(path: configName)
    }
    
    private let configName = "OrzSwiftLintConfig.yml"
    
    /// [SwiftLintRuleDirectory](https://realm.github.io/SwiftLint/rule-directory.html)
    private let configYamlFormatContent = """

indentation_width:
  indentation_width: 4
  include_compiler_directives: false
  include_comments: false
  include_multiline_strings: false

opt_in_rules:
  - indentation_width

trailing_whitespace:
  ignores_empty_lines: true

vertical_whitespace:
  max_empty_lines: 2

line_length:
  warning: 150
  error: 300
  ignores_urls: true
  ignores_function_declarations: true
  ignores_comments: true

analyzer_rules:
  - unused_import

identifier_name:
  excluded:
    - i
    - id
    - x
    - y
    - z
    - os
    - ps

type_name:
  validates_start_with_lowercase: warning

file_length:
  ignore_comment_only_lines: true


function_parameter_count:
  warning: 6

"""
}
