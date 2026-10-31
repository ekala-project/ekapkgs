{
  buildPerlPackage,
  fetchurl,
  lib,
  Moose,
  Mouse,
}:
buildPerlPackage {
  pname = "Any-Moose";
  version = "0.27";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Any-Moose-0.27.tar.gz";
    hash = "sha256-qKY+N/qALoJYvpmYORbN5FElgdyAYt5Q5z1mr24thTU=";
  };
  propagatedBuildInputs = [
    Moose
    Mouse
  ];
  meta = {
    description = "(DEPRECATED) use Moo instead";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
