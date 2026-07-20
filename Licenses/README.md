# Third-Party Licenses

This directory exposes the licenses of external libraries statically linked into the FFmpeg binaries.
The files are copied verbatim from the device slice of `libavcodec.xcframework` by `sync-frameworks.sh`.

`manifest.json` is the machine-readable inventory for consumers that need to create acknowledgements with tools
such as LicensePlist. Apple system frameworks such as AudioToolbox are not third-party components and are not listed.
