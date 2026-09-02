{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  font-util,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-bh-75dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bh-75dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-YCbYwHNWPdPLtIeNAHbu2XDeur0hQjs7Yd2QRBuefNo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    bdftopcf
    font-util
    mkfontscale
  ];

  buildInputs = [ font-util ];

  configureFlags = [ "--with-fontrootdir=$(out)/share/fonts/X11" ];

  meta = {
    description = "Luxi 75dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bh-75dpi";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.unix;
  };
})
