{
  buildPerlPackage,
  fetchurl,
  FileCopyRecursive,
  TestWarn,
  YAMLLibYAML,
  Inline,
  ParseRecDescent,
  Pegex,
}:
buildPerlPackage {
  pname = "Inline-C";
  version = "0.82";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETJ/Inline-C-0.82.tar.gz";
    hash = "sha256-EPvPHhWNHI134d2TTjeRZbEmpFwTZFrQvp3AfRUd0Mw=";
  };
  buildInputs = [
    FileCopyRecursive
    TestWarn
    YAMLLibYAML
  ];
  propagatedBuildInputs = [
    Inline
    ParseRecDescent
    Pegex
  ];
  postPatch = ''
    rm -f t/08taint.t
    rm -f t/28autowrap.t
  '';
  meta = {
    description = "C Language Support for Inline";
  };
}
