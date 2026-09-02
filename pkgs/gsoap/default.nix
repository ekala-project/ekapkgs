{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  unzip,
  m4,
  bison,
  flex,
  openssl,
  zlib,
}:

let
  majorVersion = "2.8";
in
stdenv.mkDerivation rec {
  pname = "gsoap";
  version = "${majorVersion}.108";

  src = fetchurl {
    url = "mirror://sourceforge/project/gsoap2/gsoap-${majorVersion}/gsoap_${version}.zip";
    sha256 = "0x58bwlclk7frv03kg8bp0pm7zl784samvbzskrnr7dl5v866nvl";
  };

  buildInputs = [
    openssl
    zlib
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    m4
    unzip
  ];

  # Parallel building doesn't work as of 2.8.49
  enableParallelBuilding = false;

  # Future versions of automake require subdir-objects if the source is structured this way
  prePatch = ''
    substituteInPlace configure.ac \
      --replace 'AM_INIT_AUTOMAKE([foreign])' 'AM_INIT_AUTOMAKE([foreign subdir-objects])'
  '';

  meta = {
    description = "C/C++ toolkit for SOAP web services and XML-based applications";
    homepage = "https://www.genivia.com/products.html";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
