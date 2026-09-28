{
  lib,
  stdenv,
  fetchFromGitLab,

  asciidoctor,
  bcg729,
  bison,
  buildPackages,
  c-ares,
  cmake,
  flex,
  gettext,
  glib,
  gnutls,
  libcap,
  libgcrypt,
  libgpg-error,
  libkrb5,
  libmaxminddb,
  libnl,
  libopus,
  libpcap,
  libsmi,
  libssh,
  libxml2,
  lua,
  lz4,
  makeWrapper,
  minizip,
  nghttp2,
  nghttp3,
  ninja,
  opencore-amr,
  openssl,
  pcre2,
  perl,
  pkg-config,
  python3,
  sbc,
  snappy,
  spandsp,
  speexdsp,
  wrapGAppsHook3,
  zlib-ng,
  zstd,
  brotli,

  withQt ? true,
  qt6,
  libpcap' ? libpcap.override { withBluez = stdenv.hostPlatform.isLinux; },
  withExtras ? stdenv.hostPlatform.isLinux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wireshark-${if withQt then "qt" else "cli"}";
  version = "4.6.8";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    repo = "wireshark";
    owner = "wireshark";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jvKQCjEuaWsBne2aX1QBZd8TMnlAmzAmP7H4QwyhRcs=";
  };

  patches = [
    ./patches/lookup-dumpcap-in-path.patch
  ];

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    asciidoctor
    bison
    cmake
    cmake.configurePhaseHook
    flex
    makeWrapper
    ninja
    perl
    pkg-config
    python3
  ]
  ++ lib.optionals withQt [
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    bcg729
    c-ares
    gettext
    glib
    gnutls
    libgcrypt
    libgpg-error
    libkrb5
    libmaxminddb
    libopus
    libpcap'
    libsmi
    libssh
    libxml2
    lua
    lz4
    minizip
    nghttp2
    nghttp3
    opencore-amr
    openssl
    pcre2
    snappy
    spandsp
    speexdsp
    zlib-ng
    zstd
    brotli
  ]
  ++ lib.optionals withQt (
    with qt6;
    [
      qt5compat
      qtbase
      # qtmultimedia # depends on pipewire which is currently broken
      qtsvg
      qttools
    ]
  )
  ++ lib.optionals (withQt && stdenv.hostPlatform.isLinux) [
    qt6.qtwayland
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libnl
    sbc
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    # Fix `extcap` and `plugins` paths. See https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=16444
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DENABLE_APPLICATION_BUNDLE=OFF"
    "-DLEMON_C_COMPILER=cc"
  ]
  ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DHAVE_C99_VSNPRINTF_EXITCODE__TRYRUN_OUTPUT="
    "-DHAVE_C99_VSNPRINTF_EXITCODE=0"
  ];

  # Avoid referencing -dev paths because of debug assertions.
  env.NIX_CFLAGS_COMPILE = toString [ "-DQT_NO_DEBUG" ];

  dontWrapGApps = withQt;

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  postInstall = ''
    cmake --install . --prefix "''${!outputDev}" --component Development
  ''
  + lib.optionalString withExtras ''
    ln -s $out/libexec/wireshark/extcap/* -t $out/bin/
  '';

  preFixup = lib.optionalString withQt ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "Powerful network protocol analyzer";
    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';
    homepage = "https://www.wireshark.org";
    changelog = "https://www.wireshark.org/docs/relnotes/wireshark-${finalAttrs.version}.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = if withQt then "wireshark" else "tshark";
  };
})
