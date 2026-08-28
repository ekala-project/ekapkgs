{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  xorgproto,
  libxcb,
  libxcb-util,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-image";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-image-${finalAttrs.version}.tar.xz";
    hash = "sha256-zK2O5drbEnH9RyetFNm9d6ZOUFYIdmxOmCZ9mu3kDT0=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    xorgproto
    libxcb
    libxcb-util
  ];

  propagatedBuildInputs = [ libxcb ];

  meta = {
    description = "XCB port of Xlib's XImage and XShmImage functions";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-image";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
