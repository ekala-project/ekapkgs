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
  gst-plugins-bad,
  gst-plugins-base,
  gst-plugins-good,
  gst-libav,
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
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-libav
  ];

  cmakeFlags = [
    "-DENABLE_DYNAMIC_RESOLVE_VAAPI_SYMBOLS=0"
    "-DQt6ShaderToolsTools_DIR=${pkgsBuildBuild.qt6.qtshadertools}/lib/cmake/Qt6ShaderToolsTools"
  ];
}
