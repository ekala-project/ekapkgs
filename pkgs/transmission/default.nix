{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  curl,
  libevent,
  systemd,
  zlib,
  inotify-tools,
  miniupnpc,

  # Only build the daemon by default (no GTK/Qt UI)
  enableGTK ? false,
  enableQt ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "transmission";
  version = "4.0.6";

  src = fetchFromGitHub {
    owner = "transmission";
    repo = "transmission";
    tag = finalAttrs.version;
    hash = lib.fakeHash;
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs =
    [
      openssl
      curl
      libevent
      zlib
      miniupnpc
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      systemd
      inotify-tools
    ];

  cmakeFlags = [
    "-DENABLE_DAEMON=ON"
    "-DENABLE_CLI=ON"
    "-DENABLE_GTK=${if enableGTK then "ON" else "OFF"}"
    "-DENABLE_QT=${if enableQt then "ON" else "OFF"}"
    "-DENABLE_TESTS=OFF"
    "-DINSTALL_DOC=OFF"
  ];

  meta = {
    description = "Fast, easy, and free BitTorrent client";
    homepage = "https://transmissionbt.com";
    changelog = "https://github.com/transmission/transmission/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "transmission-daemon";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
