{
  lib,
  stdenv,
  fetchurl,
  perl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "hspell";
  version = "1.4";

  src = fetchurl {
    url = "http://hspell.ivrix.org.il/hspell-${version}.tar.gz";
    hash = "sha256-cxD11YdA0h1tIVwReWWGAu99qXqBa8FJfIdkvpeqvqM=";
  };

  PERL_USE_UNSAFE_INC = "1";

  patches = [ ./remove-shared-library-checks.patch ];

  postPatch = "patchShebangs .";

  postInstall = ''
    patchShebangs --update $out/bin/multispell
  '';

  nativeBuildInputs = [
    perl
    zlib
  ];

  buildInputs = [
    perl
    zlib
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Hebrew spell checker";
    homepage = "http://hspell.ivrix.org.il/";
    platforms = platforms.all;
    license = licenses.gpl2;
  };
}
