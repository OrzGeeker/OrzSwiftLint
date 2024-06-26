# OrzSwiftLint

Perform unified lint checking for all swift projects in OrzGeeker

## Usage

### Xcode Target 

![xcode use swift package plugin](https://github.com/OrzGeeker/OrzSwiftLint/raw/main/images/xcode-plugin-usage.png)

### Swift Package Package

```swift
    .target(
        name: "<You Swift Package Name>",
        plugins: [
            .plugin(name: "OrzSwiftLintBuildToolPlugin", package: "OrzSwiftLint")
        ]
    )
```

## Reference

- [SwiftLint in Depth](https://www.kodeco.com/38422105-swiftlint-in-depth)

- [SwiftLint](https://swiftpackageindex.com/realm/SwiftLint)

- [raywenderlich rules](https://github.com/kodecocodes/swift-style-guide/blob/main/com.raywenderlich.swiftlint.yml)
