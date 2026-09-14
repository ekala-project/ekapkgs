# GStreamer multimedia framework
#
# This scope provides the full GStreamer plugin ecosystem:
#   - core: The core GStreamer library and tools
#   - base: Essential plugins (audio/video basics, OpenGL, Wayland, X11)
#   - good: Well-maintained plugins with clean licenses (LGPL)
#   - bad: Plugins of varying quality or with uncertain licensing
#   - ugly: Good-quality plugins with problematic patents/licenses
#   - libav: FFmpeg-based decoder/encoder plugins
#   - rtsp-server: RTSP streaming server library
#   - devtools: Testing and debugging infrastructure (validate, dots-viewer)
#
# TODO: Port gst-editing-services (NLE/timeline editing)
# TODO: Port gst-plugins-rs (Rust-based plugins — requires full Rust toolchain integration)
# TODO: Port gstreamermm (C++ bindings)
{
  lib,
  newScope,
}:

lib.makeScope newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    gstreamer = callPackage ./core { };

    gst-plugins-base = callPackage ./base { };

    gst-plugins-good = callPackage ./good { };

    gst-plugins-bad = callPackage ./bad { };

    gst-plugins-ugly = callPackage ./ugly { };

    gst-libav = callPackage ./libav { };

    gst-rtsp-server = callPackage ./rtsp-server { };

    gst-devtools = callPackage ./devtools { };
  }
)
