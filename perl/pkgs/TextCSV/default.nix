{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Text-CSV";
  version = "2.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/Text-CSV-2.03.tar.gz";
    hash = "sha256-SLvOnyNJNaiFlWGOBN0UFigkbWUPKnJgJN8cE34LZfs=";
  };
  meta = {
    description = "Comma-separated values manipulator (using XS or PurePerl)";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
