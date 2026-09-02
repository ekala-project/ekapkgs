{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorg,
  xorgproto,
}:

stdenv.mkDerivation rec {
  pname = "libXxf86dga";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libXxf86dga-${version}.tar.xz";
    sha256 = "03wqsxbgyrdbrhw8fk3fxc9nk8jnwz5537ym2yif73w0g5sl4i5y";
  };

  hardeningDisable = [
    "bindnow"
    "relro"
  ];

  strictDeps = true;
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    xorg.libX11
    xorg.libXext
    xorgproto
  ];

  meta = {
    description = "X11 Direct Graphics Access extension library";
    homepage = "https://xorg.freedesktop.org/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}
