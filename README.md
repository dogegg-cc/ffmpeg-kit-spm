# FFmpegKit Swift Package Manager (iOS)

这是一个专为 iOS 平台设计的、自包含的 **Swift Package Manager (SPM)** 项目，用于集成与维护预编译的 `ffmpeg-kit` 及其依赖的 7 个底层 FFmpeg C 核心二进制 `xcframework`。

---

## 📌 平台与版本支持

- **最低 iOS 版本**: `iOS 15.0`
- **支持架构**: 
  - `iPhoneOS` (真机: `arm64`)
  - `iPhoneSimulator` (模拟器: `arm64`, `x86_64`)

---

## 📦 包含的二进制组件

此 SPM 包在内部自动分发并链接以下 8 个二进制 `xcframework`：

1. **`ffmpegkit.xcframework`** - FFmpegKit 核心 Objective-C/Swift 包装器
2. **`libavcodec.xcframework`** - 编解码核心库
3. **`libavdevice.xcframework`** - 设备输入/输出库
4. **`libavfilter.xcframework`** - 音视频滤镜核心库
5. **`libavformat.xcframework`** - 封装/解封装核心库
6. **`libavutil.xcframework`** - 通用工具核心库
7. **`libswresample.xcframework`** - 音频重采样库
8. **`libswscale.xcframework`** - 图像色彩空间转换与缩放库

---

## 🚀 集成与使用指南

### 1. 导入到您的 Xcode 项目

#### 💡 方式 A：本地集成 (Local Package - 推荐本地开发使用)
1. 在您的主 Xcode 项目（`.xcodeproj` 或 `.xcworkspace`）中，选择 **File** ➔ **Add Packages...**。
2. 点击左下角的 **Add Local...** 按钮。
3. 选择您本地的 `ffmpeg-kit-spm` 文件夹，点击 **Add Package**。
4. 在您主 App Target 的 **Frameworks, Libraries, and Embedded Content** 中，添加并勾选 `FFmpegKit` 依赖。

#### 🌐 方式 B：远程 Git 集成 (独立分发使用)
1. 将本 `ffmpeg-kit-spm` 目录作为一个独立的 Git 仓库推送到您的代码托管平台（例如 GitHub/GitLab）。
   > ⚠️ **注意**：由于二进制包体积较大，建议在推送前为 `Frameworks/` 目录下的 `.xcframework` 配置 **Git LFS**。
2. 在您的 Xcode 项目中选择 **File** ➔ **Add Packages...**。
3. 在右上角搜索框中输入该仓库的 Git URL，选择对应的分支或版本号引入即可。

---

### 2. 编写 Swift 代码

集成成功后，只需在需要使用音视频处理的 Swift 文件中直接 `import ffmpegkit` 即可：

```swift
import UIKit
import ffmpegkit

class VideoProcessor {
    func checkFFmpegVersion() {
        // 1. 获取当前集成的 FFmpeg 核心版本
        if let ffmpegVersion = FFmpegKitConfig.getFFmpegVersion() {
            print("🎉 FFmpeg 核心版本: \(ffmpegVersion)")
        }
        
        // 2. 异步执行一条简单的 FFmpeg 命令（例如获取视频信息）
        let videoPath = "input.mp4"
        FFmpegKit.execute(async: "-i \(videoPath)") { session in
            guard let session = session else { return }
            
            let returnCode = session.getReturnCode()
            if ReturnCode.isSuccess(returnCode) {
                print("✅ 视频处理成功！")
            } else if ReturnCode.isCancel(returnCode) {
                print("ℹ️ 视频处理被取消。")
            } else {
                print("❌ 视频处理失败，错误码: \(returnCode?.getValue() ?? -1)")
            }
        }
    }
}
```

---

## 🛠 维护与更新说明

当主工程 `ffmpeg-kit` 重新编译并输出了新的二进制 `xcframework` 时，您可以通过以下极简步骤更新本 SPM 包的二进制文件：

1. 打开终端并进入 `ffmpeg-kit-spm` 目录：
   ```bash
   cd ffmpeg-kit-spm
   ```
2. 运行一键同步脚本：
   ```bash
   ./sync-frameworks.sh
   ```
   > 脚本将自动清理 `Frameworks/` 目录下的旧包，并将平级目录 `../ffmpeg-kit/prebuilt/bundle-apple-xcframework-ios` 中最新生成的 8 个 `xcframeworks` 一键拷贝同步到本项目中。
3. 提交最新的变更至 Git 仓库即可。
