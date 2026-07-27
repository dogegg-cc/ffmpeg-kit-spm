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

#ifndef CFFMPEG_H
#define CFFMPEG_H

#include <stdint.h>

#include <libavformat/avformat.h>
#include <libavformat/avio.h>

#include <libavcodec/avcodec.h>
#include <libavcodec/codec.h>
#include <libavcodec/codec_id.h>
#include <libavcodec/codec_par.h>
#include <libavcodec/packet.h>

#include <libavutil/avutil.h>
#include <libavutil/channel_layout.h>
#include <libavutil/error.h>
#include <libavutil/frame.h>
#include <libavutil/mathematics.h>
#include <libavutil/mem.h>
#include <libavutil/opt.h>
#include <libavutil/rational.h>
#include <libavutil/samplefmt.h>

#include <libswresample/swresample.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * These functions only verify that the CFFmpeg headers and dynamic-link
 * dependency closure are complete. Consumers should call FFmpeg's public API
 * directly for playback behavior.
 */
uint32_t cffmpeg_avformat_version(void);
uint32_t cffmpeg_avcodec_version(void);
uint32_t cffmpeg_avutil_version(void);
uint32_t cffmpeg_swresample_version(void);

#ifdef __cplusplus
}
#endif

#endif /* CFFMPEG_H */
