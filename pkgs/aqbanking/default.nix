{
  lib,
  stdenv,
  fetchurl,
  gmp,
  gwenhywfar,
  libtool,
  libxml2,
  libxslt,
  pkg-config,
  gettext,
  xmlsec,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "aqbanking";
  version = "6.5.12beta";

  src = fetchurl {
    url = "https://www.aquamaniac.de/rdm/attachments/download/526/${pname}-${version}.tar.gz";
    hash = "sha256-TH6+eEiULmOciB1Mqo4vjgF9JbF4BW+llrTjS6BtctY=";
  };

  postPatch = ''
    sed -i '/^set_and_check(AQBANKING_INCLUDE_DIRS "@aqbanking_headerdir@")/i set_and_check(includedir "@includedir@")' aqbanking-config.cmake.in
    sed -i -e '/^aqbanking_plugindir=/ {
      c aqbanking_plugindir="\''${libdir}/gwenhywfar/plugins"
    }' configure
  '';

  buildInputs = [
    gmp
    gwenhywfar
    libtool
    libxml2
    libxslt
    xmlsec
    zlib
  ];

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  meta = {
    description = "Interface to banking tasks, file formats and country information";
    homepage = "https://www.aquamaniac.de/rdm/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
