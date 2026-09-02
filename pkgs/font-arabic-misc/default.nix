{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-arabic-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-arabic-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-Rv/mG1LHih0tynD/IKny2E1pdEY5yrmghcen7hdmNGc=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Arabic newspaper pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/arabic-misc";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
