{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Carp-Clan";
  version = "6.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Carp-Clan-6.08.tar.gz";
    hash = "sha256-x1+S40QizFplqwXRVYQrcBRSQ06a77ZJ1uIonEfvZwg=";
  };
  meta = {
    description = "Report errors from perspective of caller of a \"clan\" of modules";
    homepage = "https://github.com/karenetheridge/Carp-Clan";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
