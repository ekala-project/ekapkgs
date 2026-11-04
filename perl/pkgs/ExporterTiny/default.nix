{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Exporter-Tiny";
  version = "1.006002";

  src = fetchurl {
    url = "mirror://cpan/authors/id/T/TO/TOBYINK/Exporter-Tiny-1.006002.tar.gz";
    hash = "sha256-byleLL/7HbwVvbna3DQWccHgzSvfLTErF1Jic8MiY40=";
  };

  meta = {
    description = "Exporter with the features of Sub::Exporter but only core dependencies";
    homepage = "https://metacpan.org/release/Exporter-Tiny";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
