{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  asciidoc,
  pkg-config,
  cmark,
  coeurl ? null,
  curl,
  kdsingleapplication,
  libevent,
  libsecret,
  lmdb,
  lmdbxx,
  mtxclient ? null,
  nlohmann_json,
  olm,
  python3,
  re2,
  spdlog,
  gstreamer,
  libnice,
  qt6Packages,
  withVoipSupport ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nheko";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "Nheko-Reborn";
    repo = "nheko";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WlWxe4utRSc9Tt2FsnhBwxzQsoDML2hvm3g5zRnDEiU=";
  };

  patches = [
    # Fixes rendering replies with QT 6.9.2
    (fetchpatch {
      url = "https://github.com/Nheko-Reborn/nheko/commit/2769642d3c7bd3c0d830b2f18ef6b3bf6a710bf4.patch";
      hash = "sha256-y8aiS6h5CSJYBdsAH4jYhAyrFug7aH2H8L6rBfULnQQ=";
    })
    ./fix-darwin-build.patch
    # Fix for Qt 6.10
    (fetchpatch {
      url = "https://github.com/Nheko-Reborn/nheko/commit/af2ca72030deb14a920a888e807dc732d93e3714.patch";
      hash = "sha256-tlYrfEoUkdJoVzvfF34IhXdn1AxLO0MOlp9rzuFivws=";
    })
  ];

  nativeBuildInputs = [
    asciidoc
    cmake
    cmake.configurePhaseHook
    lmdbxx
    pkg-config
    python3.pkgs.setuptools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    cmark
    coeurl
    curl
    kdsingleapplication
    libevent
    libsecret
    lmdb
    mtxclient
    nlohmann_json
    olm
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtimageformats
    qt6Packages.qtmultimedia
    qt6Packages.qtsvg
    qt6Packages.qttools
    re2
    spdlog
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    qt6Packages.qtwayland
  ]
  ++ lib.optionals withVoipSupport [
    gstreamer
    gstreamer.plugins-base
    gstreamer.plugins-good
    gstreamer.plugins-bad
    libnice
  ];

  cmakeEntries = {
    VOIP = withVoipSupport;
  };

  preFixup = ''
    # unset QT_STYLE_OVERRIDE to avoid showing a blank window when started
    # https://github.com/NixOS/nixpkgs/issues/333009
    qtWrapperArgs+=(--unset QT_STYLE_OVERRIDE)
  ''
  + lib.optionalString withVoipSupport ''
    # add gstreamer plugins path to the wrapper
    qtWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out/Applications/nheko.app/Contents/MacOS/nheko" "$out/bin/nheko"
  '';

  meta = {
    description = "Desktop client for the Matrix protocol";
    homepage = "https://github.com/Nheko-Reborn/nheko";
    license = lib.licenses.gpl3Plus;
    mainProgram = "nheko";
    platforms = lib.platforms.all;
  };
})
