{
  lib,
  stdenv,
  fetchurl,
  python3Packages,
  perl,
  flex,
  texinfo,
  libiconv,
  libintl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "recode";
  version = "3.7.15";

  src = fetchurl {
    url = "https://github.com/rrthomas/recode/releases/download/v${finalAttrs.version}/recode-${finalAttrs.version}.tar.gz";
    hash = "sha256-9ZBAf8UbrbNRlz/BMz7jMRHwXsg6j5VP2M8MXjBDmAY=";
  };

  nativeBuildInputs = [
    python3Packages.python
    perl
    flex
    texinfo
    libiconv
  ];

  buildInputs = [ libintl ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://github.com/rrthomas/recode";
    description = "Converts files between various character sets and usages";
    mainProgram = "recode";
    changelog = "https://github.com/rrthomas/recode/raw/v${finalAttrs.version}/NEWS";
    platforms = lib.platforms.unix;
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
  };
})
