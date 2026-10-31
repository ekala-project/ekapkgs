{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Type-Tiny-XS";
  version = "0.025";
  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/Type-Tiny-XS-0.025.tar.gz";
    hash = "sha256-mmFFDdqQKU9gbNej+kTzsaNmvNiKQZkXsFTuXiPRSL0=";
  };
  meta = {
    description = "Provides an XS boost for some of Type::Tiny's built-in type constraints";
    homepage = "https://metacpan.org/release/Type-Tiny-XS";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
