{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Probe-Perl";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KW/KWILLIAMS/Probe-Perl-0.03.tar.gz";
    hash = "sha256-2eTSHi53Y4VZBF+gkEaxtv/2xAO5SZKdshPjCr6KPDE=";
  };
  meta = {
    description = "Information about the currently running perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
