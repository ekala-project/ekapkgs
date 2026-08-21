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

  }
)
