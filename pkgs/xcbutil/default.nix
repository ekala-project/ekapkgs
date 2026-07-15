{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gperf,
  libxcb,
  xorgproto,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util";
  version = "0.4.1";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-${finalAttrs.version}.tar.xz";
    sha256 = "04p54r0zjc44fpw1hdy4rhygv37sx2vr2lllxjihykz5v2xkpgjs";
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
    description = "XCB utility library providing atom, aux, event and reply helpers";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-util";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [
      "xcb-atom"
      "xcb-aux"
      "xcb-event"
      "xcb-util"
    ];
    platforms = lib.platforms.unix;
  };
})
