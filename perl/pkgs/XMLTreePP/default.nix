{
  buildPerlPackage,
  fetchurl,
  LWP,
}:
buildPerlPackage {
  pname = "XML-TreePP";
  version = "0.43";
  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAWASAKI/XML-TreePP-0.43.tar.gz";
    hash = "sha256-f74tZDCGAFmJSu7r911MrPG/jXt1KU64fY4VAvgb12A=";
  };
  propagatedBuildInputs = [ LWP ];
  meta = {
    description = "Pure Perl implementation for parsing/writing XML documents";
  };
}
