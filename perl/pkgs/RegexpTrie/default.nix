{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Regexp-Trie";
  version = "0.02";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Regexp-Trie-0.02.tar.gz";
    hash = "sha256-+yv5TtjbwfSpXZ/I9xDLZ7P3lsbvycS7TCz6Prqhxfo=";
  };
  meta = {
    description = "Builds trie-ized regexp";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
