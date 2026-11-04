{
  lib,
  stdenv,
  fetchFromGitHub,
  ladspa-sdk,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tap-plugins";
  version = "0-unstable-2020-12-09";

  src = fetchFromGitHub {
    owner = "tomscii";
    repo = "tap-plugins";
    rev = "5d882799f37dffe37fc73451f2c5b4fb24316f3b";
    hash = "sha256-bwybMxIAbOzPr43QGshjbnRK5GdziGiYDsTutZdSj4s=";
  };

  buildInputs = [
    ladspa-sdk
  ];

  postPatch = ''
    substituteInPlace Makefile --replace /usr/local "$out"
  '';

  meta = {
    homepage = "https://tomscii.sig7.se/tap-plugins/";
    description = "Tom's Audio Processing plugins";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    broken = true; # source download returns 404
  };
})
