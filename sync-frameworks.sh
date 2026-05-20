#!/bin/bash

# ==============================================================================
# FFmpegKit SPM Frameworks Sync Script
# ==============================================================================
# This script copies the prebuilt iOS xcframeworks from ffmpeg-kit prebuilt 
# output directory to ffmpeg-kit-spm Frameworks directory.
# ==============================================================================

set -e

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPM_DIR="${SCRIPT_DIR}"
SOURCE_DIR="${SPM_DIR}/../ffmpeg-kit/prebuilt/bundle-apple-xcframework-ios"
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

# 创建目标目录
mkdir -p "${TARGET_DIR}"

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

# 循环同步每一个 xcframework
for xcframework in "${XCFRAMEWORKS[@]}"; do
    SRC_PATH="${SOURCE_DIR}/${xcframework}"
    DST_PATH="${TARGET_DIR}/${xcframework}"
    
    if [ -d "${SRC_PATH}" ]; then
        echo "🔄 同步: ${xcframework} ..."
        # 清理原有的目标包
        rm -rf "${DST_PATH}"
        # 复制新包
        cp -R "${SRC_PATH}" "${DST_PATH}"
        echo "✅ 完成: ${xcframework}"
    else
        echo "⚠️ 警告: 找不到源包 ${SRC_PATH}，跳过。"
    fi
done

echo "=================================================="
echo "🎉 同步完成！所有可用的 xcframework 均已存入 Frameworks 目录。"
echo "=================================================="
