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
  pname = "libxcb-wm";
  version = "0.4.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-wm-${finalAttrs.version}.tar.xz";
    hash = "sha256-YsNOIdBiZGh/rqftv2NjLJ8E1V5yEUqkpXu5Xk+Iigs=";
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
    description = "XCB utility library for window manager hints";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-wm";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
