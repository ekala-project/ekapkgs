{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chrpath";
  version = "0.18";

  src = fetchurl {
    url = "https://codeberg.org/pere/chrpath/archive/release-${finalAttrs.version}.tar.gz";
    hash = "sha256-8JxJ8GGGYMoR/G2VgN3ekExyJNTG0Pby0fm83JECyao=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  meta = {
    description = "Command line tool to adjust the RPATH or RUNPATH of ELF binaries";
    mainProgram = "chrpath";
    homepage = "https://codeberg.org/pere/chrpath";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
