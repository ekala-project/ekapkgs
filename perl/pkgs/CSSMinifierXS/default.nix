{
  buildPerlPackage,
  fetchurl,
  lib,
  TestDiagINC,
}:
buildPerlPackage {
  pname = "CSS-Minifier-XS";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/G/GT/GTERMARS/CSS-Minifier-XS-0.15.tar.gz";
    hash = "sha256-iprSIxYtpGceP4EsSlXyl3OUg70xar2kH0wn6K3XhVM=";
  };
  buildInputs = [ TestDiagINC ];
  meta = {
    description = "XS based CSS minifier";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
