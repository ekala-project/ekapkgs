{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Email-Address";
  version = "1.913";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Address-1.913.tar.gz";
    hash = "sha256-avtUH232tTXM92QtNhrhjXqVo/k6zhvFNz9kwkEMpa8=";
  };

  meta = {
    description = "RFC 2822 Address Parsing and Creation";
    homepage = "https://github.com/rjbs/Email-Address";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
