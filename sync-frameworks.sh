#!/bin/bash

# ==============================================================================
# FFmpegKit SPM Frameworks Sync Script
# ==============================================================================
# This script copies the prebuilt iOS xcframeworks from FFmpegKitNext prebuilt
# output directory to ffmpeg-kit-spm Frameworks directory.
# ==============================================================================

set -e

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPM_DIR="${SCRIPT_DIR}"
SOURCE_DIR="${SPM_DIR}/../ffmpeg-kit-next/prebuilt/bundle-apple-xcframework-ios-17.0"
TARGET_DIR="${SPM_DIR}/Frameworks"

echo "=================================================="
echo "🚀 开始同步 FFmpegKit prebuilt xcframeworks..."
echo "📂 源目录: ${SOURCE_DIR}"
echo "📂 目标目录: ${TARGET_DIR}"
echo "=================================================="

# 验证源目录是否存在
if [ ! -d "${SOURCE_DIR}" ]; then
    echo "❌ 错误: 找不到源目录 ${SOURCE_DIR}"
    echo "💡 请确保已成功运行 ffmpeg-kit 的构建脚本并生成了 xcframeworks。"
    exit 1
fi

# 产物是一个原子集合。先确认 8 个包全部存在，再清空旧目录。

# 声明需要同步的 xcframework 列表
XCFRAMEWORKS=(
    "ffmpegkit.xcframework"
    "libavcodec.xcframework"
    "libavdevice.xcframework"
    "libavfilter.xcframework"
    "libavformat.xcframework"
    "libavutil.xcframework"
    "libswresample.xcframework"
    "libswscale.xcframework"
)

# 在删除旧产物前验证完整性
for xcframework in "${XCFRAMEWORKS[@]}"; do
    SRC_PATH="${SOURCE_DIR}/${xcframework}"
    if [ ! -d "${SRC_PATH}" ]; then
        echo "❌ 错误: 找不到源包 ${SRC_PATH}"
        echo "💡 为避免生成不完整的动态依赖闭包，本次未修改 Frameworks。"
        exit 1
    fi
done

rm -rf "${TARGET_DIR}"
mkdir -p "${TARGET_DIR}"

# 同步完整的动态框架依赖闭包
for xcframework in "${XCFRAMEWORKS[@]}"; do
    echo "🔄 同步: ${xcframework} ..."
    cp -R "${SOURCE_DIR}/${xcframework}" "${TARGET_DIR}/${xcframework}"
    echo "✅ 完成: ${xcframework}"
done

echo "=================================================="
echo "🎉 同步完成！所有可用的 xcframework 均已存入 Frameworks 目录。"
echo "=================================================="
