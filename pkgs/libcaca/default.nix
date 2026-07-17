{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  imlib2,
  ncurses,
  pkg-config,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcaca";
  version = "0.99.beta20";

  src = fetchFromGitHub {
    owner = "cacalabs";
    repo = "libcaca";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N0Lfi0d4kjxirEbIjdeearYWvStkKMyV6lgeyNKXcVw=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2026-42046.patch";
      url = "https://github.com/cacalabs/libcaca/commit/fb77acff9ba6bb01d53940da34fb10f20b156a23.patch";
      hash = "sha256-AdpiE5Gw/CVET//7TTYZCb0glW5HY+T8xZkYs1XCBvY=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    ncurses
    zlib
    (imlib2.override { x11Support = false; })
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  configureFlags = [
    "--disable-x11"
  ];

  env.NIX_CFLAGS_COMPILE = "-DX_DISPLAY_MISSING";

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/caca-config $dev/bin/caca-config
  '';

  meta = {
    homepage = "http://caca.zoy.org/wiki/libcaca";
    description = "Graphics library that outputs text instead of pixels";
    license = lib.licenses.wtfpl;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
