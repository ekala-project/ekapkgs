{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Heap";
  version = "0.80";

  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMM/Heap-0.80.tar.gz";
    hash = "sha256-zNop88kxdq0P3/9N1vXkrJCzcMuksCg4a3NDv2QTm94=";
  };

  meta = {
    description = "Perl extensions for keeping data partially sorted";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
