{
  lib,
  stdenv,
  fetchurl,
  apacheHttpd,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "mod_perl";
  version = "2.0.13";

  src = fetchurl {
    url = "mirror://apache/perl/${pname}-${version}.tar.gz";
    sha256 = "sha256-reO+McRHuESIaf7N/KziWNbVh7jGx3PF8ic19w2C1to=";
  };

  nativeBuildInputs = [
    perl
  ];

  buildInputs = [
    apacheHttpd
    perl
  ];

  buildPhase = ''
    perl Makefile.PL \
      MP_APXS=${apacheHttpd.dev}/bin/apxs
    make
  '';

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
    mv $out${apacheHttpd}/* $out
    mv $out${apacheHttpd.dev}/* $out
    mv $out${perl}/* $out
    rm $out/nix -rf
  '';

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Integration of perl with the Apache2 web server";
    homepage = "https://perl.apache.org/download/index.html";
    changelog = "https://github.com/apache/mod_perl/blob/trunk/Changes";
    license = lib.licenses.asl20;
    mainProgram = "mp2bug";
    platforms = lib.platforms.unix;
  };
}
