{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  gperf,
  libxcb,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-keysyms";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-keysyms-${finalAttrs.version}.tar.xz";
    hash = "sha256-fCYKUpRBKu1CnfHaL4r9O9B7fLo/7HcvuhWmE6bVxjg=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    gperf
    libxcb
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  meta = {
    description = "XCB utility library for X11 keysyms";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-keysyms";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
