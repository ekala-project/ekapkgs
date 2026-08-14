{
  lib,
  stdenv,
  fetchurl,
  bdftopcf,
  mkfontscale,
  writeScript,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "font-jis-misc";
  version = "1.0.4";

  src = fetchurl {
    url = "mirror://xorg/individual/font/font-jis-misc-${finalAttrs.version}.tar.xz";
    hash = "sha256-eNHv9sRx96poAqJtYszPUdjlGFWGQG2bbh7mkbC/+tA=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    bdftopcf
    mkfontscale
  ];

  meta = {
    description = "JIS X 9051: 1984 pcf font";
    homepage = "https://gitlab.freedesktop.org/xorg/font/jis-misc";
    # licensing is unclear:
    # - COPYING just says "permission to use"
    # - The industial standard (JIS X 9051: 1984) this is from, is paid.
    license = lib.licenses.unfree;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
