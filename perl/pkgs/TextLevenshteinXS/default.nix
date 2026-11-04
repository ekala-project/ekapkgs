{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-LevenshteinXS";
  version = "0.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JG/JGOLDBERG/Text-LevenshteinXS-0.03.tar.gz";
    hash = "sha256-43T/eyN5Gc5eqSRfNW0ctSzIf9JrOlo4s/Pl/4KgFJE=";
  };
  meta = {
    description = "Levenshtein edit distance in a XS way";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
