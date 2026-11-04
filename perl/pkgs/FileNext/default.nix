{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {

  pname = "File-Next";
  version = "1.18";
  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/File-Next-1.18.tar.gz";
    hash = "sha256-+QDLOVBetuFoqcpRoQtz8bveGRS5I6CezXLZwC5uwu8=";
  };
  meta = {
    description = "File-finding iterator";
    license = lib.licenses.artistic2;
  };
}
