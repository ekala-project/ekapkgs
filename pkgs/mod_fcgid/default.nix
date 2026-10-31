{
  lib,
  stdenv,
  fetchurl,
  apacheHttpd,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "mod_fcgid";
  version = "2.3.9";

  src = fetchurl {
    url = "https://archive.apache.org/dist/httpd/mod_fcgid/mod_fcgid-${version}.tar.bz2";
    hash = "sha256-RCwpUo40/vyUbdNW/PgkDhlTrtietVl/xViY09BvGD8=";
  };

  buildInputs = [ apacheHttpd ];
  nativeBuildInputs = [ perl ];

  configurePhase = ''
    runHook preConfigure
    APXS=${apacheHttpd.dev}/bin/apxs ./configure.apxs
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/modules
    cp modules/fcgid/.libs/mod_fcgid.so $out/modules/
    runHook postInstall
  '';

  meta = {
    description = "FastCGI module for the Apache HTTP Server";
    homepage = "https://httpd.apache.org/mod_fcgid/";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
  };
}
