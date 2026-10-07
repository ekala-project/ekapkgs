{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,

  # nativeBuildInputs
  cmake,
  ninja,
  pkg-config,
  gtk3,

  # buildInputs
  alsa-lib,
  alsa-plugins,
  ffmpeg,
  flac,
  freetype,
  harfbuzz,
  qt6,
  lame,
  libjack2,
  libogg,
  libopus,
  libopusenc,
  libpulseaudio,
  libsndfile,
  libvorbis,
  mnxdom,
  portaudio,
  portmidi,
  pugixml,
  utf8cpp,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "musescore";
  version = "4.7.5";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WzVsItF4cyhd99Ax0BWkiX3JoxPY9+xpag7fu8yORD0=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/musescore/MuseScore/commit/f273501e418842351c4bda10cce32b0e329eaff1.patch";
      hash = "sha256-zrZRzeAHSFGtCuw/o4A3b1Blbo3FxKGxw1UDu9IggzY=";
    })
  ];

  cmakeEntries = {
    MUSE_APP_BUILD_MODE = "release";
    MUSE_MODULE_DIAGNOSTICS_CRASHPAD_CLIENT = false;
  };

  cmakeFlags = [
    (lib.cmakeBool "MUSE_ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
  ]
  ++ map (l: lib.cmakeBool "MUE_COMPILE_USE_SYSTEM_${l}" true) [
    "FREETYPE"
    "HARFBUZZ"
    "MNXDOM"
    "OPUSENC"
    "FLAC"
    "PUGIXML"
    "LAME"
    "UTF8CPP"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "MUE_BUILD_MACOS_INTEGRATION" false)
  ];

  qtWrapperArgs = [
    "--prefix"
    "${lib.optionalString stdenv.hostPlatform.isDarwin "DY"}LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ libjack2 ])
  ]
  ++ lib.optionals (stdenv.hostPlatform.isLinux) [
    "--set"
    "ALSA_PLUGIN_DIR"
    "${alsa-plugins}/lib/alsa-lib"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "--set-default"
    "QT_QPA_PLATFORM"
    "xcb"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  dontWrapGApps = true;

  nativeBuildInputs = [
    cmake
    cmake.configurePhaseHook
    qt6.qttools
    qt6.wrapQtAppsHook
    ninja
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk3.wrapGAppsHook
  ];

  buildInputs = [
    flac
    freetype
    harfbuzz
    qt6.qt5compat
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtnetworkauth
    qt6.qtscxml
    qt6.qtsvg
    lame
    libjack2
    libogg
    libopus
    libopusenc
    libpulseaudio
    libsndfile
    libvorbis
    mnxdom
    portaudio
    portmidi
    pugixml
    utf8cpp
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    qt6.qtwayland
  ];

  preConfigure = ''
    substituteInPlace src/framework/media/internal/ffmpegutils.cpp \
      --replace-fail "/usr/lib/x86_64-linux-gnu" "${lib.getLib ffmpeg}/lib" \
      --replace-fail "/opt/homebrew/lib" "${lib.getLib ffmpeg}/lib" \

    # Work around broken harfbuzz cmake config: the dev output's cmake config
    # resolves PACKAGE_PREFIX_DIR to the dev prefix, but .so files live in the
    # out output. Create a patched cmake config with correct absolute paths.
    mkdir -p $TMPDIR/harfbuzz-fix/lib/cmake/harfbuzz
    sed \
      -e 's|"''${PACKAGE_PREFIX_DIR}/lib/|"${lib.getLib harfbuzz}/lib/|g' \
      -e 's|''${PACKAGE_PREFIX_DIR}/../[^/]*/include|${harfbuzz.dev}/include|g' \
      ${harfbuzz.dev}/lib/cmake/harfbuzz/harfbuzz-config.cmake \
      > $TMPDIR/harfbuzz-fix/lib/cmake/harfbuzz/harfbuzz-config.cmake
    export CMAKE_PREFIX_PATH="$TMPDIR/harfbuzz-fix:$CMAKE_PREFIX_PATH"
  '';

  strictDeps = true;
  __structuredAttrs = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications"
    mv "$out/mscore.app" "$out/Applications/mscore.app"
    mkdir -p $out/bin
    ln -s $out/Applications/mscore.app/Contents/MacOS/mscore $out/bin/mscore
  '';

  dontWrapQtApps = stdenv.hostPlatform.isLinux;
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/libexec
    mv $out/bin/mscore $out/libexec
    makeQtWrapper $out/libexec/mscore $out/bin/mscore
  '';

  doCheck = false;

  meta = {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = lib.licenses.gpl3Only;
    mainProgram = "mscore";
    platforms = lib.platforms.unix;
  };
})
