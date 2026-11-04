{
  buildPerlPackage,
  fetchurl,
  lib,
  graphviz,
  TestPod,
  FileWhich,
  IPCRun,
  ParseRecDescent,
  XMLTwig,
  XMLXPath,
}:
buildPerlPackage {
  pname = "GraphViz";
  version = "2.26";

  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETJ/GraphViz-2.26.tar.gz";
    hash = "sha256-ml0lILMmK/MEdSct12SkRfjn+TG++Ivg49O/9EXacyg=";
  };

  nativeBuildInputs = [ graphviz ];

  buildInputs = [
    graphviz
    TestPod
  ];

  propagatedBuildInputs = [
    FileWhich
    IPCRun
    ParseRecDescent
    XMLTwig
    XMLXPath
  ];

  meta = {
    description = "Perl interface to the GraphViz graphing tool";
    license = lib.licenses.artistic2;
  };
}
