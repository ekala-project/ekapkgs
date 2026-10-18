{
  version,
  src-hash,
  withFullDeps ? false,
  mkVariantPassthru,
  ...
}@variantArgs:

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  openssl,
  curl,
  libevent,
  inotify-tools,
  systemd,
  zlib,
  miniupnpc,
  # Full deps (only used when withFullDeps = true)
  rapidjson,
  libb64,
  libdeflate,
  utf8cpp,
  fast-float,
  fmt,
  libpsl,
  dht,
  libnatpmp,
  # Build options
  enableGTK ? withFullDeps,
  gtk4,
  gtkmm4,
  libpthread-stubs,
  libayatana-appindicator,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  enableDaemon ? true,
  enableCli ? true,
  installLib ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  inherit version;

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    tag = version;
    hash = src-hash;
    fetchSubmodules = true;
  };

  strictDeps = true;

  patches = lib.optionals withFullDeps [
    ./0001-Skip-bundle-fixup.patch
  ];

  cmakeEntries = {
    ENABLE_CLI = enableCli;
    ENABLE_DAEMON = enableDaemon;
    ENABLE_GTK = enableGTK;
    ENABLE_MAC = false;
    ENABLE_QT = false;
    INSTALL_LIB = installLib;
    RUN_CLANG_TIDY = false;
  } // lib.optionalAttrs (!withFullDeps) {
    ENABLE_TESTS = false;
    INSTALL_DOC = false;
  };

  postPatch = lib.optionalString withFullDeps ''
    # Clean third-party libraries to ensure system ones are used where possible.
    # Keep small, libutp, and other vendored-only deps.
    pushd third-party
    for f in *; do
        if [[ ! $f =~ googletest|wildmat|wide-integer|jsonsl|madler-crcany|small|libutp ]]; then
            rm -r "$f"
        fi
    done
    popd
    rm \
      cmake/FindFastFloat.cmake \
      cmake/FindFmt.cmake \
      cmake/FindRapidJSON.cmake \
      cmake/FindUtfCpp.cmake
    # Upstream uses different config file name.
    substituteInPlace CMakeLists.txt \
      --replace-fail 'find_package(UtfCpp)' 'find_package(utf8cpp)'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    cmake.configurePhaseHook
  ]
  ++ lib.optionals withFullDeps [ python3 ]
  ++ lib.optionals enableGTK [ gtk4.wrapGAppsHook ];

  buildInputs = [
    curl
    libevent
    miniupnpc
    openssl
    zlib
  ]
  ++ lib.optionals withFullDeps [
    dht
    fast-float
    fmt
    libb64
    libdeflate
    libnatpmp
    libpsl
    rapidjson
    utf8cpp
  ]
  ++ lib.optionals enableGTK [
    gtkmm4
    libpthread-stubs
    libayatana-appindicator
  ]
  ++ lib.optionals enableSystemd [ systemd ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm0444 -t $out/share/icons ../icons/hicolor_apps_scalable_transmission.svg
  '';

  passthru = mkVariantPassthru variantArgs;

  meta = {
    description = "Fast, easy and free BitTorrent client";
    mainProgram = if enableGTK then "transmission-gtk" else if enableDaemon then "transmission-daemon" else "transmission-cli";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
    '';
    homepage = "https://www.transmissionbt.com/";
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
