{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  alsa-lib,
  boost,
  chromaprint,
  fftw,
  glib-networking,
  gnutls,
  gstreamer,
  kdsingleapplication,
  libxdmcp,
  libcdio,
  libebur128,
  libmtp,
  libpthread-stubs,
  libpulseaudio,
  libselinux,
  libsepol,
  libtasn1,
  p11-kit,
  sqlite,
  taglib,
  sparsehash,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "strawberry";
  version = "1.2.21";

  src = fetchFromGitHub {
    owner = "strawberrymusicplayer";
    repo = "strawberry";
    rev = finalAttrs.version;
    hash = "sha256-FI+lyVx9x82o2HZ9YysIlPsSAl94YUD8nrHP0HsmO2E=";
  };

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    ninja
    pkg-config
    qt6.qttools
    qt6.wrapQtAppsHook
    util-linux
  ];

  buildInputs = [
    alsa-lib
    boost
    chromaprint
    fftw
    gnutls
    kdsingleapplication
    libxdmcp
    libcdio
    libebur128
    libmtp
    libpthread-stubs
    libtasn1
    qt6.qtbase
    sqlite
    taglib
    sparsehash
    libpulseaudio
    libselinux
    libsepol
    p11-kit
    # TODO(corepkgs): add libidn2
    glib-networking
    gstreamer.pkgs.gst-libav
    gstreamer.pkgs.gst-plugins-bad
    gstreamer.pkgs.gst-plugins-base
    gstreamer.pkgs.gst-plugins-good
    gstreamer.pkgs.gst-plugins-ugly
    gstreamer
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_GPOD" false)
  ];

  postInstall = ''
    qtWrapperArgs+=(
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0"
      --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules"
    )
  '';

  meta = {
    description = "Music player and music collection organizer";
    homepage = "https://www.strawberrymusicplayer.org/";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "strawberry";
  };
})
