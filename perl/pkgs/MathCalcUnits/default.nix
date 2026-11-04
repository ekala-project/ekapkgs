{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Math-Calc-Units";
  version = "1.07";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SF/SFINK/Math-Calc-Units-1.07.tar.gz";
    hash = "sha256-YePP2ye7O+4nvrlxJN2TB2DhA57cHreBbC9WJ3Zfj48=";
  };

  meta = {
    description = "Human-readable unit-aware calculator";
    license = with lib.licenses; [
      artistic1
      gpl2Only
    ];
  };
}
