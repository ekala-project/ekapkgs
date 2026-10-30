{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  python3,
  xorg,
  xcbproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-errors";
  version = "1.0.1";

  src = fetchurl {
    url = "https://xorg.freedesktop.org/archive/individual/lib/xcb-util-errors-${finalAttrs.version}.tar.xz";
    hash = "sha256-VijIe5hCWa2Se6zYpClYMZw2vfSwZYh4A8nYIPuA81c=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    xorg.utilmacros
  ];

  buildInputs = [
    xorg.libxcb
    xcbproto
  ];

  meta = {
    description = "XCB utility library that gives human readable names to error, event, and request codes";
    homepage = "https://xcb.freedesktop.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
