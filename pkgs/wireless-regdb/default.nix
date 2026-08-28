{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "wireless-regdb";
  version = "2026.05.30";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-${version}.tar.xz";
    hash = "sha256-iie/wIG6/tjCTdcPqw2W8JjloL/NCNPaZyWV8iWriZM=";
  };

  dontBuild = true;

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "PREFIX="
  ];

  meta = {
    description = "Wireless regulatory database for CRDA";
    homepage = "https://wireless.docs.kernel.org/en/latest/en/developers/regulatory/wireless-regdb.html";
    license = lib.licenses.isc;
    platforms = lib.platforms.all;
  };
}
