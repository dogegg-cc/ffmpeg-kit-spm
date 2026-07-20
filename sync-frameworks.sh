#!/bin/bash

# ==============================================================================
# FFmpegKit SPM Frameworks Sync Script
# ==============================================================================
# This script copies the prebuilt iOS xcframeworks from FFmpegKitNext prebuilt
# output directory to ffmpeg-kit-spm Frameworks directory.
# ==============================================================================

set -euo pipefail

# 获取脚本所在目录的绝对路径
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPM_DIR="${SCRIPT_DIR}"
SOURCE_DIR="${SPM_DIR}/../ffmpeg-kit-next/prebuilt/bundle-apple-xcframework-ios-17.0"
TARGET_DIR="${SPM_DIR}/Frameworks"
LICENSE_TARGET_DIR="${SPM_DIR}/Licenses"

# 这些许可证对应静态链接进 FFmpeg 二进制的外部库。将它们同步到仓库根目录，
# 是为了让 LicensePlist 等只扫描 Swift Package 顶层文件的工具也能稳定读取。
THIRD_PARTY_LICENSES=(
    "LICENSE.LAME"
    "LICENSE.LIBOGG"
    "LICENSE.LIBVORBIS"
    "LICENSE.OPUS"
    "LICENSE.SOXR"
)

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

LICENSE_SOURCE_DIR="${SOURCE_DIR}/libavcodec.xcframework/ios-arm64/libavcodec.framework"

# 许可证与二进制同属一个原子发布集合，缺少任意文件都不能继续同步。
for license_file in "${THIRD_PARTY_LICENSES[@]}"; do
    if [ ! -f "${LICENSE_SOURCE_DIR}/${license_file}" ]; then
        echo "❌ 错误: 找不到第三方许可证 ${LICENSE_SOURCE_DIR}/${license_file}"
        echo "💡 本次未修改 Frameworks 或 Licenses，避免许可证清单与二进制不一致。"
        exit 1
    fi
done

# 如果新构建引入了额外外部库，要求先显式更新清单，防止静默漏发许可证。
for license_path in "${LICENSE_SOURCE_DIR}"/LICENSE.*; do
    [ -e "${license_path}" ] || continue
    license_name="$(basename "${license_path}")"
    is_known=false
    for expected_license in "${THIRD_PARTY_LICENSES[@]}"; do
        if [ "${license_name}" = "${expected_license}" ]; then
            is_known=true
            break
        fi
    done
    if [ "${is_known}" = false ]; then
        echo "❌ 错误: 发现未登记的第三方许可证 ${license_name}"
        echo "💡 请先更新 THIRD_PARTY_LICENSES 和 Licenses/manifest.json。"
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

mkdir -p "${LICENSE_TARGET_DIR}"
rm -f "${LICENSE_TARGET_DIR}"/LICENSE.* "${LICENSE_TARGET_DIR}/manifest.json"

for license_file in "${THIRD_PARTY_LICENSES[@]}"; do
    cp "${LICENSE_SOURCE_DIR}/${license_file}" "${LICENSE_TARGET_DIR}/${license_file}"
    echo "✅ 已同步许可证: ${license_file}"
done

cat > "${LICENSE_TARGET_DIR}/manifest.json" <<'EOF'
{
  "schemaVersion": 1,
  "components": [
    {
      "name": "LAME",
      "license": "LGPL-2.0-or-later",
      "licenseFile": "LICENSE.LAME",
      "source": "https://lame.sourceforge.io/"
    },
    {
      "name": "libogg",
      "license": "BSD-3-Clause",
      "licenseFile": "LICENSE.LIBOGG",
      "source": "https://xiph.org/ogg/"
    },
    {
      "name": "Vorbis",
      "license": "BSD-3-Clause",
      "licenseFile": "LICENSE.LIBVORBIS",
      "source": "https://xiph.org/vorbis/"
    },
    {
      "name": "Opus",
      "license": "BSD-3-Clause",
      "licenseFile": "LICENSE.OPUS",
      "source": "https://opus-codec.org/"
    },
    {
      "name": "SoX Resampler",
      "license": "LGPL-2.1-or-later",
      "licenseFile": "LICENSE.SOXR",
      "source": "https://sourceforge.net/projects/soxr/"
    }
  ]
}
EOF

echo "=================================================="
echo "🎉 同步完成！XCFramework 与第三方许可证已同步。"
echo "=================================================="
