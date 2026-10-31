{
  buildPerlPackage,
  fetchurl,
  lib,
  TestNeeds,
  Moose,
  TieToObject,
  namespaceclean,
}:
buildPerlPackage {
  pname = "Data-Visitor";
  version = "0.32";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Visitor-0.32.tar.gz";
    hash = "sha256-sZQpDyV8xidaA5N0ERVUxmahZQ5MAa15nB4KJ39HkX0=";
  };
  buildInputs = [ TestNeeds ];
  propagatedBuildInputs = [
    Moose
    TieToObject
    namespaceclean
  ];
  meta = {
    description = "Visitor style traversal of Perl data structures";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
