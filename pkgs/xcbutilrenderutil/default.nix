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
  pname = "xcb-util-renderutil";
  version = "0.3.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/xcb/xcb-util-renderutil-${finalAttrs.version}.tar.xz";
    sha256 = "1fh4dnlwlqyccrhmmwlv082a7mxc7ss7vmzmp7xxp39dwbqd859y";
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
    description = "XCB utility library for the Render extension";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-render-util";
    license = lib.licenses.x11;
    maintainers = [ ];
    pkgConfigModules = [ "xcb-renderutil" ];
    platforms = lib.platforms.unix;
  };
})
