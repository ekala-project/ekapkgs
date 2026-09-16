{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Getopt-Long";
  version = "2.58";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JV/JV/Getopt-Long-2.58.tar.gz";
    hash = "sha256-EwXtRuoh95QwTpeqPc06OFGQWXhenbdBXa8sIYUGxWk=";
  };
  meta = {
    description = "Extended processing of command line options";
    license = with lib.licenses; [
      artistic1
      gpl2Plus
    ];
  };
}
