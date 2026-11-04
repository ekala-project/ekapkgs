{
  buildPerlPackage,
  fetchurl,
  lib,
  CGI,
}:
buildPerlPackage {
  pname = "HTTP-Lite";
  version = "2.44";

  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/HTTP-Lite-2.44.tar.gz";
    hash = "sha256-OOQ9eRHPwU46OPA4K2zHptVZMH0jsQnOc6x9JKmz53w=";
  };

  buildInputs = [ CGI ];

  meta = {
    description = "Lightweight HTTP implementation";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
