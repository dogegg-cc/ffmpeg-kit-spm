/*
 * Copyright (c) 2026 dogegg-cc
 *
 * This file is part of FFmpegKit Swift Package.
 *
 * FFmpegKit Swift Package is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation; either version 3 of the License,
 * or (at your option) any later version.
 *
 * FFmpegKit Swift Package is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser
 * General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with FFmpegKit Swift Package. If not, see <https://www.gnu.org/licenses/>.
 */

#include "CFFmpeg.h"

uint32_t cffmpeg_avformat_version(void) {
    return avformat_version();
}

uint32_t cffmpeg_avcodec_version(void) {
    return avcodec_version();
}

uint32_t cffmpeg_avutil_version(void) {
    return avutil_version();
}

uint32_t cffmpeg_swresample_version(void) {
    return swresample_version();
}
