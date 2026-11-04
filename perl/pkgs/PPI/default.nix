{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassInspector,
  Clone,
  IOString,
  ParamsUtil,
  TaskWeaken,
  TestDeep,
  TestNoWarnings,
  TestObject,
  TestSubCalls,
}:
buildPerlPackage {
  pname = "PPI";
  version = "1.277";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MITHALDU/PPI-1.277.tar.gz";
    hash = "sha256-h8efg7aHbiBgUZZdUBnSUHxVH4GahnUAgOx+xDsuCvg=";
  };

  # override default postPatch to avoid patchShebangs breaking tests
  postPatch = "";

  buildInputs = [
    ClassInspector
    TestDeep
    TestNoWarnings
    TestObject
    TestSubCalls
  ];

  propagatedBuildInputs = [
    Clone
    IOString
    ParamsUtil
    TaskWeaken
  ];

  preCheck = "
    # Remove test that fails due to unexpected shebang after patchShebang.
    rm t/03_document.t
    # Remove tests with hardcoded line numbers.
    rm t/29_logical_filename.t
  ";

  meta = {
    description = "Parse, Analyze and Manipulate Perl (without perl)";
    homepage = "https://github.com/Perl-Critic/PPI";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
