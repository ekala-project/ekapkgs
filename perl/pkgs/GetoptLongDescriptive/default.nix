{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANMetaCheck,
  TestFatal,
  TestWarnings,
  ParamsValidate,
  SubExporter,
  GetoptLong,
}:
buildPerlPackage {
  pname = "Getopt-Long-Descriptive";
  version = "0.114";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Getopt-Long-Descriptive-0.114.tar.gz";
    hash = "sha256-QQ6EIRSpy/0/06X9JIqWcDwHxdh5sqpfnbAzPyMnYBY=";
  };

  buildInputs = [
    CPANMetaCheck
    TestFatal
    TestWarnings
  ];

  propagatedBuildInputs = [
    ParamsValidate
    SubExporter
    GetoptLong
  ];

  meta = {
    description = "Getopt::Long, but simpler and more powerful";
    homepage = "https://github.com/rjbs/Getopt-Long-Descriptive";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
