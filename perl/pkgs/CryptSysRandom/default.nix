{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Crypt-SysRandom";
  version = "0.007";

  src = fetchurl {
    url = "mirror://cpan/authors/id/L/LE/LEONT/Crypt-SysRandom-0.007.tar.gz";
    hash = "sha256-pdSemPyjxSZsea6YmoXsoik0sFiAPuSz5usI78pO70Y=";
  };

  meta = {
    description = "Perl interface to system randomness";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
