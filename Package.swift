// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FFmpegKit",
    platforms: [
        .iOS(.v15)
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
    ],
    dependencies: [],
    targets: [
        // 8 个底层的二进制 xcframework target (指向本地的 Frameworks 文件夹)
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
        )
    ]
)
