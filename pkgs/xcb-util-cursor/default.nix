{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gperf,
  libxcb,
  libxcb-image,
  libxcb-renderutil,
  xorgproto,
  m4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xcb-util-cursor";
  version = "0.1.5";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/xcb-util-cursor-${finalAttrs.version}.tar.xz";
    sha256 = "0mrwcrm6djbd5zdvqb5v4wr87bzawnaacyqwwhfghw09ssq9kbqc";
  };

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    gperf
    libxcb
    libxcb-image
    libxcb-renderutil
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  meta = {
    description = "XCB cursor library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor";
    license = lib.licenses.x11;
    pkgConfigModules = [ "xcb-cursor" ];
    platforms = lib.platforms.unix;
  };
})
