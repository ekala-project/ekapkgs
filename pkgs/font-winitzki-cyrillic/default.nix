{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-winitzki-cyrillic";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-winitzki-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-O22CEi3BR3bjr82HeDOng04fkAxT/Bx7stZ8eBz6l6g=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Winitzki Proof Cyrillic pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/winitzki-cyrillic";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
})
