{
  qtModule,
  lib,
  stdenv,
  qtbase,
  qtdeclarative,
  qtquick3d,
  qtshadertools,
  qtsvg,
  pkg-config,
  alsa-lib,
  gstreamer,
  ffmpeg,
  libva,
  libpulseaudio,
  pipewire,
  wayland,
  libxrandr,
  elfutils,
  libunwind,
  orc,
  pkgsBuildBuild,
}:

qtModule {
  pname = "qtmultimedia";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ffmpeg
    libunwind
    orc
    libpulseaudio
    pipewire
    alsa-lib
    wayland
    libxrandr
    libva
  ]
  ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform elfutils) [ elfutils ];
  propagatedBuildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtshadertools
    qtquick3d
    gstreamer
    gstreamer.pkgs.gst-plugins-bad
    gstreamer.pkgs.gst-plugins-base
    gstreamer.pkgs.gst-plugins-good
    gstreamer.pkgs.gst-libav
  ];

  cmakeEntries = {
    ENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS = false;
    Qt6ShaderToolsTools_DIR = "${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools";
  };
}
