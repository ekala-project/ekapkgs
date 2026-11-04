{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "IO-All";
  version = "0.87";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FR/FREW/IO-All-0.87.tar.gz";
    hash = "sha256-VOIdJQwCKRJ+MLd6NGHhAHeFTsJE8m+2cPG0Re1MTVs=";
  };
  meta = {
    description = "Combines all of the best Perl IO modules into a single nifty object oriented interface";
    homepage = "https://github.com/ingydotnet/io-all-pm";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
