{
  buildPerlPackage,
  fetchurl,
  PadWalker,
}:
buildPerlPackage {
  pname = "Devel-Caller";
  version = "2.07";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/Devel-Caller-2.07.tar.gz";
    hash = "sha256-tnmisYA0sLcg3oLDcIckw2SxCmyhZMvGfNw68oPzUD8=";
  };
  propagatedBuildInputs = [ PadWalker ];
  meta = {
    description = "Meatier versions of caller";
  };
}
