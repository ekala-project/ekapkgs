{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-micro-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-micro-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-LuC51r166Emv8b2C76tEobazaPu14R0S/38BWj32+UM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Micro pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/micro-misc";
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.unix;
  };
})
