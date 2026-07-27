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

import ffmpegkit
import XCTest

final class FFmpegKitCompatibilityTests: XCTestCase {
    func testExistingExecuteStillWorks() {
        let session = FFmpegKit.execute("-version")
        XCTAssertTrue(ReturnCode.isSuccess(session?.getReturnCode()))
    }
}
