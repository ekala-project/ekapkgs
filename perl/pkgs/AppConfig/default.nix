{
  buildPerlPackage,
  fetchurl,
  TestPod,
}:
buildPerlPackage {
  pname = "AppConfig";
  version = "1.71";
  src = fetchurl {
    url = "mirror://cpan/authors/id/N/NE/NEILB/AppConfig-1.71.tar.gz";
    hash = "sha256-EXcCcCXssJ7mTZ+fJVYVwE214U91NsNEr2MgMuuIew8=";
  };
  buildInputs = [ TestPod ];
  meta = {
    description = "Bundle of Perl5 modules for reading configuration files and parsing command line arguments";
  };
}
