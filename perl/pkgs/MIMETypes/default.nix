{
  buildPerlPackage,
  fetchurl,
  lib,
  perl,
}:
buildPerlPackage {
  pname = "MIME-Types";
  version = "2.24";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MARKOV/MIME-Types-2.24.tar.gz";
    hash = "sha256-Yp42HyKyIL5QwtpzVOI8BFF1dwmgPCWiLzFg7blMtl8=";
  };

  meta = {
    description = "Definition of MIME types";
    homepage = "http://perl.overmeer.net/CPAN";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
