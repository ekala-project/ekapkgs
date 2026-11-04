{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTimeSet,
}:
buildPerlPackage {
  pname = "DateTime-Event-Recurrence";
  version = "0.19";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-Recurrence-0.19.tar.gz";
    hash = "sha256-+UCHiaRhEHdmyhojK7PsHnAu7HyoFnQB6m7D9LbQtaU=";
  };

  propagatedBuildInputs = [ DateTimeSet ];

  meta = {
    description = "DateTime::Set extension for create basic recurrence sets";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
