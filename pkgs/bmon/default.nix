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
  version = "4.0";

  src = fetchFromGitHub {
    owner = "tgraf";
    repo = "bmon";
    rev = "v${finalAttrs.version}";
    sha256 = "1ilba872c09mnlvylslv4hqv6c9cz36l76q74rr99jvis1dg69gf";
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
