{
  buildPerlPackage,
  fetchurl,
  TestMoreUTF8,
  TestWarnings,
}:
buildPerlPackage {
  pname = "Text-Template";
  version = "1.61";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MS/MSCHOUT/Text-Template-1.61.tar.gz";
    hash = "sha256-opXqfR7yQa4mQMH3hktij45vmewU+x2ngbL18haNzwk=";
  };
  buildInputs = [
    TestMoreUTF8
    TestWarnings
  ];
  meta = {
    description = "Expand template text with embedded Perl";
  };
}
