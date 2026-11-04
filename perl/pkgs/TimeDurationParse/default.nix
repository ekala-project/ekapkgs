{
  buildPerlPackage,
  fetchurl,
  lib,
  TimeDuration,
  ExporterLite,
}:
buildPerlPackage {
  pname = "Time-Duration-Parse";
  version = "0.16";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/Time-Duration-Parse-0.16.tar.gz";
    hash = "sha256-EISmRj7ieQ+ZIVvXaxNcpFr+K/ppmPpv1UcLaeG6vBI=";
  };
  buildInputs = [ TimeDuration ];
  propagatedBuildInputs = [ ExporterLite ];
  meta = {
    description = "Parse string that represents time duration";
    homepage = "https://github.com/neilb/Time-Duration-Parse";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
