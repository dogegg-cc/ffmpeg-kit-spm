# FFmpegKit Swift Package for iOS

这是 FileBox 使用的本地 FFmpegKit Swift Package，分发基于
[arthenica/ffmpeg-kit-next v8.1.0](https://github.com/arthenica/ffmpeg-kit-next/releases/tag/v8.1.0)
自行编译的 iOS XCFramework。

## 构建配置

- FFmpegKitNext：8.1.0
- FFmpeg：8.1.2
- 最低系统：iOS 17.0
- 真机：arm64
- 模拟器：arm64（仅 Apple Silicon）
- Bitcode：禁用
- GPL / non-free：禁用
- 外部库：LAME 3.100、Opus 1.5.2、libogg 1.3.6、libvorbis 1.3.7、soxr 0.1.3
- Apple 系统能力：AudioToolbox

不包含 Intel 模拟器、Mac Catalyst、arm64e、x86_64 或其他 Apple 平台 slice。

## 功能范围

该构建支持 FileBox 所需的视频音轨提取、音频裁剪、重采样和格式转换，包括：

- MP3：`libmp3lame`
- AAC：FFmpeg AAC 与 AudioToolbox `aac_at`
- WAV：PCM S16LE、S24LE、S32LE
- FLAC：FFmpeg FLAC
- Opus：FFmpeg Opus 与 `libopus`
- Vorbis：FFmpeg Vorbis 与 `libvorbis`
- 高质量重采样：soxr

## 包内容

`FFmpegKit` 产品包含完整的动态框架依赖闭包：

1. `ffmpegkit.xcframework`：FFmpegKit Objective-C 包装层，提供 FFmpeg/FFprobe 会话、日志、统计、取消任务和异步执行 API。
2. `libavcodec.xcframework`：编解码核心，提供 MP3、AAC、PCM、FLAC、Opus、Vorbis 等音频编解码能力。
3. `libavdevice.xcframework`：输入输出设备抽象层，同时也是 FFmpegKit 动态依赖闭包的一部分。
4. `libavfilter.xcframework`：音视频滤镜框架，用于裁剪流程中的时间轴处理、格式适配和 filter graph 操作。
5. `libavformat.xcframework`：容器与协议层，负责 MP4/M4A、MP3、WAV、FLAC、Ogg/Opus 等格式的解封装与封装。
6. `libavutil.xcframework`：FFmpeg 公共基础设施，提供内存、日志、时间戳、采样格式和声道布局等通用能力。
7. `libswresample.xcframework`：音频重采样与格式转换，负责采样率、采样格式和声道布局转换，并包含 soxr 支持。
8. `libswscale.xcframework`：视频像素格式、尺寸和色彩空间转换；提取音频时通常不直接使用，但属于完整依赖闭包。

这些二进制 target 必须一起集成和分发。Package 同时导出各 FFmpeg 子模块，
以支持 Swift Explicit Module 解析。

## 集成

在 Xcode 中选择 **File > Add Package Dependencies > Add Local**，选择本仓库目录，
然后给 App target 添加 `FFmpegKit` 产品。

```swift
import ffmpegkit

FFmpegKit.executeAsync("-i input.mp4 -vn -c:a copy output.m4a") { session in
    let returnCode = session?.getReturnCode()
    print("FFmpeg return code: \(returnCode?.getValue() ?? -1)")
}
```

## 更新二进制

先在相邻的 `ffmpeg-kit-next` 仓库生成 iOS 17 XCFramework：

```bash
./nix-ios.sh \
  -p xcode26 \
  -x \
  --spm \
  --target=17.0 \
  --no-bitcode \
  --disable-arm64e \
  --disable-x86-64 \
  --disable-arm64-mac-catalyst \
  --disable-x86-64-mac-catalyst \
  --enable-lame \
  --enable-opus \
  --enable-libvorbis \
  --enable-soxr \
  --enable-ios-audiotoolbox
```

构建成功后，在本仓库执行：

```bash
./sync-frameworks.sh
```

脚本要求 8 个 XCFramework 全部存在，才会替换 `Frameworks/`，避免发布不完整的动态依赖闭包。

## 许可证

FFmpegKitNext 与本次 FFmpeg 构建按 LGPL 3.0 分发，详见根目录 `LICENSE`。
第三方许可证随 `libavcodec.xcframework` 内的 `LICENSE.*` 文件一并分发：

- LAME：GNU Library General Public License 2.0
- soxr：GNU Lesser General Public License 2.1
- libogg、libvorbis、Opus：BSD 风格许可证

本构建未启用 `--enable-gpl` 或 non-free 组件。分发二进制时仍需履行 LGPL 和各第三方许可证义务。
