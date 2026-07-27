// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FFmpegKit",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // 导出一个主 library，直接包含 8 个预编译核心二进制库
        // 外部使用者在 iOS 项目中集成后，直接 `import ffmpegkit` 即可使用所有 API
        .library(
            name: "FFmpegKit",
            targets: [
                "ffmpegkit",
                "libavcodec",
                "libavdevice",
                "libavfilter",
                "libavformat",
                "libavutil",
                "libswresample",
                "libswscale"
            ]
        ),
        // 为 Swift 提供 FFmpeg 官方 public C API 的稳定 Clang 模块入口
        .library(name: "CFFmpeg", targets: ["CFFmpeg"]),
        // 独立导出各个底层二进制子模块，以支持 Swift Explicit Module 解析
        .library(name: "libavcodec", targets: ["libavcodec"]),
        .library(name: "libavdevice", targets: ["libavdevice"]),
        .library(name: "libavfilter", targets: ["libavfilter"]),
        .library(name: "libavformat", targets: ["libavformat"]),
        .library(name: "libavutil", targets: ["libavutil"]),
        .library(name: "libswresample", targets: ["libswresample"]),
        .library(name: "libswscale", targets: ["libswscale"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "CFFmpeg",
            dependencies: [
                "libavformat",
                "libavcodec",
                "libavutil",
                "libswresample"
            ],
            path: "Sources/CFFmpeg",
            publicHeadersPath: "include"
        ),
        // 8 个二进制 XCFramework target（仅包含 iOS arm64 真机与 arm64 模拟器）
        .binaryTarget(
            name: "ffmpegkit",
            path: "Frameworks/ffmpegkit.xcframework"
        ),
        .binaryTarget(
            name: "libavcodec",
            path: "Frameworks/libavcodec.xcframework"
        ),
        .binaryTarget(
            name: "libavdevice",
            path: "Frameworks/libavdevice.xcframework"
        ),
        .binaryTarget(
            name: "libavfilter",
            path: "Frameworks/libavfilter.xcframework"
        ),
        .binaryTarget(
            name: "libavformat",
            path: "Frameworks/libavformat.xcframework"
        ),
        .binaryTarget(
            name: "libavutil",
            path: "Frameworks/libavutil.xcframework"
        ),
        .binaryTarget(
            name: "libswresample",
            path: "Frameworks/libswresample.xcframework"
        ),
        .binaryTarget(
            name: "libswscale",
            path: "Frameworks/libswscale.xcframework"
        ),
        .testTarget(
            name: "CFFmpegTests",
            dependencies: [
                "CFFmpeg",
                "ffmpegkit"
            ],
            path: "Tests/CFFmpegTests",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
