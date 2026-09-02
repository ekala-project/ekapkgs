{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-daewoo-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-daewoo-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-9jyLPcjzAJjLhot9ssLAyLWz/Szv0EQDVpekPUx6TzE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Daewoo Gothic and Daewoo Mincho pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/daewoo-misc";
    # no license, just a copyright notice
    license = lib.licenses.unfree;
    platforms = lib.platforms.unix;
  };
})
