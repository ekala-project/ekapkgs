{
  lib,
  fetchFromGitHub,
  stdenv,
  replaceVars,
  SDL2,
  frei0r,
  ladspaPlugins,
  gettext,
  jack1,
  pkg-config,
  fftw,
  qt6,
  cmake,
  ffmpeg,
  mlt,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "shotcut";
  version = "26.7.30";

  src = fetchFromGitHub {
    owner = "mltframework";
    repo = "shotcut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZfJ4ADJBCriC67YpRiKbJKW799iJnXcS1dp7AQoz2Ew=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    SDL2
    frei0r
    ladspaPlugins
    gettext
    mlt
    fftw
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    qt6.qtcharts
    qt6.qtwebsockets
    qt6.qtwayland
  ];

  env.NIX_CFLAGS_COMPILE = "-DSHOTCUT_NOUPGRADE";

  cmakeFlags = [ "-DSHOTCUT_VERSION=${finalAttrs.version}" ];

  patches = [
    (replaceVars ./fix-mlt-ffmpeg-path.patch {
      ffmpeg = ffmpeg;
      mlt = mlt;
    })
  ];

  dontWrapGApps = true;

  qtWrapperArgs = [
    "--set"
    "FREI0R_PATH"
    "${frei0r}/lib/frei0r-1"
    "--set"
    "LADSPA_PATH"
    "${ladspaPlugins}/lib/ladspa"
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    "${lib.makeLibraryPath [
      SDL2
      jack1
    ]}"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Free, open source, cross-platform video editor";
    longDescription = ''
      An official binary for Shotcut, which includes all the
      dependencies pinned to specific versions, is provided on
      http://shotcut.org.

      If you encounter problems with this version, please contact the
      nixpkgs maintainer(s). If you wish to report any bugs upstream,
      please use the official build from shotcut.org instead.
    '';
    homepage = "https://shotcut.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "shotcut";
  };
})
