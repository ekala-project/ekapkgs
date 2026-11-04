{
  buildPerlPackage,
  fetchurl,
  TestException,
}:
buildPerlPackage {
  pname = "Tree-Simple";
  version = "1.34";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Tree-Simple-1.34.tgz";
    hash = "sha256-t+l5m9Iiu5TP+ZP312WYDL6hts0qql7L6tY1q99H0pw=";
  };
  buildInputs = [ TestException ];
  meta = {
    description = "Simple tree object";
  };
}
