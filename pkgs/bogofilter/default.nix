{
  lib,
  stdenv,
  fetchurl,
  flex,
  db,
}:

stdenv.mkDerivation rec {
  pname = "bogofilter";
  version = "1.2.5";

  src = fetchurl {
    url = "mirror://sourceforge/bogofilter/bogofilter-${version}.tar.xz";
    hash = "sha256-MkihNzv/VSxQCDStvqS2yu4EIkUWrlgfslpMam3uieo=";
  };

  buildInputs = [
    flex
    db
  ];

  doCheck = false; # needs "y" tool

  meta = {
    homepage = "http://bogofilter.sourceforge.net/";
    description = "Mail filter that classifies mail as spam or ham by statistical analysis";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
