{
  buildPerlPackage,
  fetchurl,
  XMLParser,
}:
buildPerlPackage {
  pname = "XML-Dumper";
  version = "0.81";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIKEWONG/XML-Dumper-0.81.tar.gz";
    hash = "sha256-9BcOtSNuEmG661xH3U/nO9uEuvVi3YTwHd3tRrQD+OA=";
  };

  propagatedBuildInputs = [ XMLParser ];

  meta = {
    description = "Perl module for dumping Perl objects from/to XML";
  };
}
