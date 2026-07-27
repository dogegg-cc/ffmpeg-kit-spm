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

import CFFmpeg
import Foundation
import XCTest

final class CFFmpegImportTests: XCTestCase {
    func testVersionProbesMatchPublicAPI() {
        XCTAssertEqual(cffmpeg_avformat_version(), avformat_version())
        XCTAssertEqual(cffmpeg_avcodec_version(), avcodec_version())
        XCTAssertEqual(cffmpeg_avutil_version(), avutil_version())
        XCTAssertEqual(cffmpeg_swresample_version(), swresample_version())
    }

    func testPublicTypesImport() {
        let formatContext: UnsafeMutablePointer<AVFormatContext>? = nil
        let codecContext: UnsafeMutablePointer<AVCodecContext>? = nil
        let packet: UnsafeMutablePointer<AVPacket>? = nil
        let frame: UnsafeMutablePointer<AVFrame>? = nil
        let resampler: OpaquePointer? = nil

        _ = formatContext
        _ = codecContext
        _ = packet
        _ = frame
        _ = resampler
    }

    func testAudioPlayerAPISurfaceImports() {
        _ = avformat_open_input
        _ = avformat_find_stream_info
        _ = av_find_best_stream
        _ = av_read_frame
        _ = avformat_seek_file
        _ = avformat_close_input

        _ = avcodec_find_decoder
        _ = avcodec_alloc_context3
        _ = avcodec_parameters_to_context
        _ = avcodec_open2
        _ = avcodec_send_packet
        _ = avcodec_receive_frame
        _ = avcodec_flush_buffers
        _ = avcodec_free_context

        _ = av_packet_alloc
        _ = av_packet_unref
        _ = av_packet_free
        _ = av_frame_alloc
        _ = av_frame_unref
        _ = av_frame_free

        _ = swr_alloc_set_opts2
        _ = swr_init
        _ = swr_convert
        _ = swr_free
    }

    func testOpeningLocalMP3AndReadingStreamInfo() throws {
        let url = try XCTUnwrap(
            Bundle.module.url(forResource: "silence", withExtension: "mp3")
        )
        var formatContext: UnsafeMutablePointer<AVFormatContext>?

        let openResult = url.path.withCString { path in
            avformat_open_input(&formatContext, path, nil, nil)
        }
        XCTAssertGreaterThanOrEqual(openResult, 0)
        guard openResult >= 0 else {
            return
        }

        defer {
            avformat_close_input(&formatContext)
        }

        XCTAssertGreaterThanOrEqual(
            avformat_find_stream_info(formatContext, nil),
            0
        )
    }
}
