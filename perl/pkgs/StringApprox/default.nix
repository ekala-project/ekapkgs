{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "String-Approx";
  version = "3.28";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JH/JHI/String-Approx-3.28.tar.gz";
    hash = "sha256-QyAedi2GmcsKwsB2SlRUvcIwbAdxAU1sj7qCFIBjE0I=";
  };
  meta = {
    description = "Perl extension for approximate matching (fuzzy matching)";
    license = with lib.licenses; [
      artistic2
      gpl2Only
    ];
  };
}
