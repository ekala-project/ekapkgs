{
  buildPerlPackage,
  fetchurl,
  lib,
  BitVector,
}:
buildPerlPackage {
  pname = "Date-Calc";
  version = "6.4";
  src = fetchurl {
    url = "mirror://cpan/authors/id/S/ST/STBEY/Date-Calc-6.4.tar.gz";
    hash = "sha256-fOE3sueXt8CQHzrfGgWhk0M1bNHwRnaqHFap9iT4Wa0=";
  };
  propagatedBuildInputs = [ BitVector ];
  doCheck = false; # some of the checks rely on the year being <2015
  meta = {
    description = "Gregorian calendar date calculations";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
