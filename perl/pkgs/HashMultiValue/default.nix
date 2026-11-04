{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Hash-MultiValue";
  version = "0.16";

  src = fetchurl {
    url = "mirror://cpan/authors/id/A/AR/ARISTOTLE/Hash-MultiValue-0.16.tar.gz";
    hash = "sha256-Zhgd96po4nhvr2iVyIsYuVyACo5Ob7TAf9F2QQo8c/Q=";
  };

  meta = {
    description = "Store multiple values per key";
    homepage = "https://github.com/miyagawa/Hash-MultiValue";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
