{
  lib,
  stdenv,
  fetchurl,
  elfutils,
  xxhash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dwz";
  version = "0.16";

  src = fetchurl {
    url = "https://www.sourceware.org/ftp/dwz/releases/dwz-${finalAttrs.version}.tar.gz";
    hash = "sha256-R1hT4bSebtjMLQqQnHpPwcxXHrzPxmJ4/UM0Lb4n1Q4=";
  };

  nativeBuildInputs = [ elfutils ];

  buildInputs = [
    xxhash
    elfutils
  ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  strictDeps = true;

  meta = {
    homepage = "https://sourceware.org/dwz/";
    description = "DWARF optimization and duplicate removal tool";
    mainProgram = "dwz";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
})
