{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTime,
}:
buildPerlPackage {
  pname = "DateTime-HiRes";
  version = "0.04";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-HiRes-0.04.tar.gz";
    hash = "sha256-HCMVkzLDD566VLdeZpK+TeqAUiQ+r/MCbJyQuLZLw5U=";
  };
  propagatedBuildInputs = [ DateTime ];
  meta = {
    description = "Create DateTime objects with sub-second current time resolution";
    homepage = "https://metacpan.org/release/DateTime-HiRes";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
