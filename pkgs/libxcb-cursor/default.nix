{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  libxcb,
  libxcb-image ? null,
  libxcb-render-util ? null,
  xorgproto,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libxcb-cursor";
  version = "0.1.6";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://xorg/individual/lib/xcb-util-cursor-${finalAttrs.version}.tar.xz";
    hash = "sha256-/euL0SeHNRm+XMcNzQ07XTO2Z4dyAPmSWln9ytj3qTM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];

  buildInputs = [
    libxcb
    libxcb-image
    libxcb-render-util
    xorgproto
  ];

  propagatedBuildInputs = [ libxcb ];

  meta = {
    description = "XCB port of libxcursor";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libxcb-cursor";
    license = lib.licenses.x11;
    platforms = lib.platforms.unix;
  };
})
