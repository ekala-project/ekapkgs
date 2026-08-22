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
  rapidjson,
  libb64,
  libdeflate,
  utf8cpp,
  fast-float,
  fmt,
  libpsl,
  miniupnpc,
  dht,
  libnatpmp,
  # Build options
  enableGTK ? true,
  gtkmm4,
  libpthread-stubs,
  libayatana-appindicator,
  wrapGAppsHook4,
  enableSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
  enableDaemon ? true,
  enableCli ? true,
  installLib ? false,
}:

let
  inherit (lib) cmakeBool optionals optionalString;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    tag = finalAttrs.version;
    hash = "sha256-4349gc7+1k0y5CwHTQe8bLQsuNW5w7pckR0MCeulIEE=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  patches = [
    ./0001-Skip-bundle-fixup.patch
  ];

  cmakeFlags = [
    (cmakeBool "ENABLE_CLI" enableCli)
    (cmakeBool "ENABLE_DAEMON" enableDaemon)
    (cmakeBool "ENABLE_GTK" enableGTK)
    (cmakeBool "ENABLE_MAC" false)
    (cmakeBool "ENABLE_QT" false)
    (cmakeBool "INSTALL_LIB" installLib)
    (cmakeBool "RUN_CLANG_TIDY" false)
  ];

  postPatch = ''
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
    python3
  ]
  ++ optionals enableGTK [ wrapGAppsHook4 ];

  buildInputs = [
    curl
    dht
    fast-float
    fmt
    libb64
    libdeflate
    libevent
    libnatpmp
    libpsl
    miniupnpc
    openssl
    rapidjson
    utf8cpp
    zlib
  ]
  ++ optionals enableGTK [
    gtkmm4
    libpthread-stubs
    libayatana-appindicator
  ]
  ++ optionals enableSystemd [ systemd ]
  ++ optionals stdenv.hostPlatform.isLinux [ inotify-tools ];

  postInstall = optionalString stdenv.hostPlatform.isLinux ''
    install -Dm0444 -t $out/share/icons ../icons/hicolor_apps_scalable_transmission.svg
  '';

  meta = {
    description = "Fast, easy and free BitTorrent client";
    mainProgram = if enableGTK then "transmission-gtk" else "transmission-cli";
    longDescription = ''
      Transmission is a BitTorrent client which features a simple interface
      on top of a cross-platform back-end.
    '';
    homepage = "https://www.transmissionbt.com/";
    maintainers = [ ];
    license = with lib.licenses; [
      gpl2Plus
      mit
    ];
    platforms = lib.platforms.unix;
  };
})
