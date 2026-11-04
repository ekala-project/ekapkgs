{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassAccessorChained,
  TestException,
}:
buildPerlPackage {
  pname = "Data-Page";
  version = "2.03";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETHER/Data-Page-2.03.tar.gz";
    hash = "sha256-LvpSFn0ferNZAs8yrgJ3amI3BdeRnUEYmBKHsETOPYs=";
  };
  propagatedBuildInputs = [ ClassAccessorChained ];
  buildInputs = [ TestException ];
  meta = {
    description = "Help when paging through sets of results";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
