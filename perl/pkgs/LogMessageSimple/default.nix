{
  buildPerlPackage,
  fetchurl,
  lib,
  LogMessage,
}:
buildPerlPackage {
  pname = "Log-Message-Simple";
  version = "0.10";

  src = fetchurl {
    url = "mirror://cpan/authors/id/B/BI/BINGOS/Log-Message-Simple-0.10.tar.gz";
    hash = "sha256-qhLRpMCsJguU1Ej6Af66JCqKhctsv9xmQy47W0aK3ZY=";
  };

  propagatedBuildInputs = [ LogMessage ];

  meta = {
    description = "Simplified interface to Log::Message";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
