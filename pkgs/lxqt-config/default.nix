{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  glib,
  kwindowsystem,
  libxscrnsaver,
  libxcursor,
  libxdmcp,
  libkscreen ? null,
  liblxqt,
  libpthread-stubs,
  libqtxdg,
  libxcb,
  lxqt-build-tools,
  lxqt-menu-data ? null,
  pkg-config,
  qt6,
  xf86-input-libinput,
  xkeyboard_config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lxqt-config";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-config";
    tag = finalAttrs.version;
    hash = "sha256-BG3+/QZkqCZp7kdaHgiruOMq506l8+9KKNq+IUgoTPw=";
  };

  postPatch = ''
    substituteInPlace lxqt-config-appearance/configothertoolkits.cpp \
      --replace-fail 'QStringLiteral("gsettings' \
                'QStringLiteral("${glib.bin}/bin/gsettings'

    substituteInPlace lxqt-config-input/keyboardlayoutconfig.h \
      --replace-fail '/usr/share/X11/xkb/rules/base.lst' \
                '${xkeyboard_config}/share/X11/xkb/rules/base.lst'
  '';

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    pkg-config
    lxqt-build-tools
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    glib.bin
    kwindowsystem
    libxscrnsaver
    libxcursor
    libxdmcp
    libkscreen
    liblxqt
    libpthread-stubs
    libqtxdg
    libxcb
    lxqt-menu-data
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    xf86-input-libinput
    xf86-input-libinput.dev
  ];

  cmakeEntries = {
    CMAKE_CXX_STANDARD = "20";
  };

  meta = {
    homepage = "https://github.com/lxqt/lxqt-config";
    description = "Tools to configure LXQt and the underlying operating system";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
})
