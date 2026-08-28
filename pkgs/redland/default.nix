{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  openssl,
  libxslt,
  perl,
  curl,
  libxml2,
  librdf_rasqal,
  gmp,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "redland";
  version = "1.0.17";

  src = fetchurl {
    url = "http://download.librdf.org/source/redland-${version}.tar.gz";
    sha256 = "de1847f7b59021c16bdc72abb4d8e2d9187cd6124d69156f3326dd34ee043681";
  };

  nativeBuildInputs = [
    perl
    pkg-config
  ];

  buildInputs = [
    openssl
    libxslt
    curl
    libxml2
    gmp
    sqlite
  ];

  propagatedBuildInputs = [ librdf_rasqal ];

  postInstall = "rm -rvf $out/share/gtk-doc";

  configureFlags = [ "--with-threads" ];

  NIX_CFLAGS_LINK = "-lraptor2";

  doCheck = false;

  meta = {
    description = "C libraries that provide support for the Resource Description Framework (RDF)";
    homepage = "https://librdf.org/";
    platforms = lib.platforms.unix;
    license = lib.licenses.asl20;
  };
}
