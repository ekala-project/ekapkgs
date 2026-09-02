{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-sony-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-sony-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-5rCfgj/MsG4L0LIGIoO2UUFTMjvYp0hunC4/VauElGs=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Sony pcf fonts";
    homepage = "https://gitlab.freedesktop.org/xorg/font/sony-misc";
    license = lib.licenses.hpnd;
    platforms = lib.platforms.unix;
  };
})
