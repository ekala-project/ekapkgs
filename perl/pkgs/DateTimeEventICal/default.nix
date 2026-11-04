{
  buildPerlPackage,
  fetchurl,
  lib,
  DateTimeEventRecurrence,
}:
buildPerlPackage {
  pname = "DateTime-Event-ICal";
  version = "0.13";

  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FG/FGLOCK/DateTime-Event-ICal-0.13.tar.gz";
    hash = "sha256-U9pDhO9c8w7ofcATH0tu7iEhzA66NHFioyi5vPr0deo=";
  };

  propagatedBuildInputs = [ DateTimeEventRecurrence ];

  meta = {
    description = "DateTime rfc2445 recurrences";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
