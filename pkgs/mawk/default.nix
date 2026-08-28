{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mawk";
  version = "1.3.4-20240819";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/mawk/mawk-${finalAttrs.version}.tgz"
      "https://invisible-island.net/archives/mawk/mawk-${finalAttrs.version}.tgz"
    ];
    hash = "sha256-bh/ejuetilwVOCMWhj/WtMbSP6t4HdWrAXf/o+6arlw=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  meta = {
    homepage = "https://invisible-island.net/mawk/mawk.html";
    changelog = "https://invisible-island.net/mawk/CHANGES";
    description = "Interpreter for the AWK Programming Language";
    license = lib.licenses.gpl2Only;
    mainProgram = "mawk";
    platforms = lib.platforms.unix;
  };
})
