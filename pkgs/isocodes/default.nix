{
  lib,
  stdenv,
  fetchurl,
  gettext,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "iso-codes";
  version = "4.17.0";

  src = fetchurl {
    url =
      with finalAttrs;
      "https://salsa.debian.org/iso-codes-team/iso-codes/-/archive/v${version}/${pname}-v${version}.tar.gz";
    hash = "sha256-3VyhPbd+xt0cwl9cAYQpCocOwf7SRdjjmgT/NPWQdsM=";
  };

  nativeBuildInputs = [
    gettext
    python3
  ];

  enableParallelBuilding = true;

  meta = {
    homepage = "https://salsa.debian.org/iso-codes-team/iso-codes";
    description = "Various ISO codes packaged as XML files";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
  };
})
