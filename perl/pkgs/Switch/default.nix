{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "Switch";
  version = "2.17";
  src = fetchurl {
    url = "mirror://cpan/authors/id/C/CH/CHORNY/Switch-2.17.tar.gz";
    hash = "sha256-MTVJdRQP5iNawTChCUlkka0z3UL5xiGJ4j9J91+TbXU=";
  };
  doCheck = false; # FIXME: 2/293 test failures
  meta = {
    description = "Switch statement for Perl, do not use if you can use given/when";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
