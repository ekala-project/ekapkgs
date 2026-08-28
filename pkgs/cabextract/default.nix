{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cabextract";
  version = "1.11";

  src = fetchurl {
    url = "https://www.cabextract.org.uk/cabextract-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-tVRtsRVeTHGP89SyeFc2BPMN1kw8W/1GV80Im4I6OsY=";
  };

  configureFlags = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_func_fnmatch_works=yes"
  ];

  meta = {
    homepage = "https://www.cabextract.org.uk/";
    description = "Free Software for extracting Microsoft cabinet files";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
    mainProgram = "cabextract";
  };
})
