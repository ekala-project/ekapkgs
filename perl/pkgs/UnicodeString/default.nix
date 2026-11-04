{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Unicode-String";
  version = "2.10";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GA/GAAS/GAAS/Unicode-String-2.10.tar.gz";
    hash = "sha256-iUoRDs5HlUaviv7Aly7scyDIbE3qTms1Tf88dSa6m2g=";
  };
  meta = {
    description = "String of Unicode characters (UTF-16BE)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
