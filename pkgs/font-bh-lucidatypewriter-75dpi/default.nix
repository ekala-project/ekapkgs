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
  pname = "font-bh-lucidatypewriter-75dpi";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-bh-lucidatypewriter-75dpi-${finalAttrs.version}.tar.xz";
    hash = "sha256-hk4sOaxh8E9pP8LIqq7SSymMLNQCg87BLu5FnFY16PU=";
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
    description = "Lucida Sans Typewriter 75dpi pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/bh-lucidatypewriter-75dpi";
    # no license just a copyright notice
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
  };
})
