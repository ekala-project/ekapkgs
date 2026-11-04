{
  buildPerlModule,
  fetchurl,
  lib,
  HTTPMessage,
  ModuleBuildTiny,
  TestMockTime,
  TestRequires,
  TryTiny,
  URI,
  POSIXstrftimeCompiler,
}:
buildPerlModule {
  pname = "Apache-LogFormat-Compiler";
  version = "0.36";

  src = fetchurl {
    url = "mirror://cpan/authors/id/K/KA/KAZEBURO/Apache-LogFormat-Compiler-0.36.tar.gz";
    hash = "sha256-lFCVA+506oIBg9BwwRYw7lvA/YwSy3T66VPtYuShrBc=";
  };

  buildInputs = [
    HTTPMessage
    ModuleBuildTiny
    TestMockTime
    TestRequires
    TryTiny
    URI
  ];

  propagatedBuildInputs = [ POSIXstrftimeCompiler ];

  prePatch = "rm t/04_tz.t";

  meta = {
    description = "Compile a log format string to perl-code";
    homepage = "https://github.com/kazeburo/Apache-LogFormat-Compiler";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
