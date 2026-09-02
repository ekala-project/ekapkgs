{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-mutt-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-mutt-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-sSNZ9OEsI7z8tEi5GCl+l1+pG+9Sk9iNPCU0PMdouyQ=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "ClearU pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/mutt-misc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
