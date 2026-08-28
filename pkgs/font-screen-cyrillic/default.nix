{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-screen-cyrillic";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-screen-cyrillic-${finalAttrs.version}.tar.xz";
    hash = "sha256-j3WLuM1YDH5lVIfR0Ntp0xmsrlTZMrKV2W2dm4P95cA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "Screen Cyrillic pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/screen-cyrillic";
    license = lib.licenses.cronyx;
    platforms = lib.platforms.unix;
  };
})
