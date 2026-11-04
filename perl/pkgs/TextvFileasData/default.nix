{
  buildPerlPackage,
  fetchurl,
  ClassAccessorChained,
}:
buildPerlPackage {
  pname = "Text-vFile-asData";
  version = "0.08";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RC/RCLAMP/Text-vFile-asData-0.08.tar.gz";
    hash = "sha256-spGrXg+YfFFyVgppIjRxGnXkWW2DR19y0BJ4NpUy+Co=";
  };
  propagatedBuildInputs = [ ClassAccessorChained ];
  meta = {
    description = "Parse vFile formatted files into data structures";
  };
}
