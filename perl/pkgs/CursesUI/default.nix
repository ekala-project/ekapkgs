{
  buildPerlPackage,
  fetchurl,
  lib,
  Curses,
  TermReadKey,
}:
buildPerlPackage {
  pname = "Curses-UI";
  version = "0.9609";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MD/MDXI/Curses-UI-0.9609.tar.gz";
    hash = "sha256-CrgnpRO24UQDGE+wZajqHS69oSLSF4y/RceB8xEkDq8=";
  };
  propagatedBuildInputs = [
    Curses
    TermReadKey
  ];
  meta = {
    description = "Curses based OO user interface framework";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
