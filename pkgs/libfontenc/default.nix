{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorgproto,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfontenc";
  version = "1.1.9";

  src = fetchurl {
    url = "mirror://xorg/individual/lib/libfontenc-${finalAttrs.version}.tar.xz";
    hash = "sha256-nYOScFyxCAPV/h0n0jbLqz9mTiaEHOAZFru+Qwzyc+I=";
  };

  strictDeps = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    xorgproto
    zlib
  ];

  meta = {
    description = "X font encoding library";
    homepage = "https://gitlab.freedesktop.org/xorg/lib/libfontenc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
