{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
  grim,
  makeBinaryWrapper,
  kdsingleapplication,
  qt-color-widgets,
  gtk3,
  enableWlrSupport ? true,
  enableMonochromeIcon ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flameshot";
  version = "14.0.0";

  src = fetchFromGitHub {
    owner = "flameshot-org";
    repo = "flameshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GnJ3nOJyyqQbCTMrTYhnQfEOXqCy0x3IapX/PsaZ3VI=";
  };

  # The multiline project() in CMakeLists.txt causes parseShareDocName to fail
  # under set -e -o pipefail, so we set this explicitly.
  shareDocName = "flameshot";

  cmakeEntries = {
    CMAKE_CXX_FLAGS = "-I${kdsingleapplication}/include/kdsingleapplication-qt6";
    USE_BUNDLED_KDSINGLEAPPLICATION = false;
    DISABLE_UPDATE_CHECKER = true;
    USE_MONOCHROME_ICON = enableMonochromeIcon;
    USE_WAYLAND_CLIPBOARD = false;
  };

  patches = [
    ./load-missing-deps.patch
    ./macos-build.patch
  ];

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    qt6.qttools
    qt6.wrapQtAppsHook
    makeBinaryWrapper
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    kdsingleapplication
    qt-color-widgets
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  dontWrapGApps = true;
  dontWrapQtApps = true;

  postFixup = ''
    wrapProgram $out/bin/flameshot \
      ${lib.optionalString enableWlrSupport "--prefix PATH : ${lib.makeBinPath [ grim ]}"} \
      ''${qtWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = {
    description = "Powerful yet simple to use screenshot software";
    homepage = "https://github.com/flameshot-org/flameshot";
    changelog = "https://github.com/flameshot-org/flameshot/releases";
    mainProgram = "flameshot";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
