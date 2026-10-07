{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  ncurses,
  libconfuse,
  libnl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bmon";
  version = "5.0";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JBjyOKhAwrBibRZXjJE4yehO+6BbW0bic4N9TBPg7KU=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/macports/macports-ports/raw/6d1dd5e9c8fae608bd22f3ede21e576f29c6358c/net/bmon/files/patch-fix__unused.diff";
      extraPrefix = "";
      sha256 = "sha256-UYIiJZzipsx9a0xabrKfyj8TWNW7IM77oXnVnSPkQkc=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    libconfuse
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux libnl;

  preConfigure = ''
    export PKG_CONFIG="$(command -v "$PKG_CONFIG")"
  '';

  meta = {
    description = "Network bandwidth monitor";
    homepage = "https://github.com/tgraf/bmon";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    mainProgram = "bmon";
  };
})
