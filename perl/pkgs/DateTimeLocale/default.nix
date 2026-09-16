{
  buildPerlPackage,
  fetchurl,
  lib,
  CPANMetaCheck,
  FileShareDirInstall,
  IPCSystemSimple,
  PathTiny,
  Test2PluginNoWarnings,
  Test2Suite,
  TestFileShareDir,
  FileShareDir,
  ParamsValidationCompiler,
  Specio,
  namespaceautoclean,
}:
buildPerlPackage {
  pname = "DateTime-Locale";
  version = "1.39";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/DateTime-Locale-1.39.tar.gz";
    hash = "sha256-EMFFpsfa9xGIZOl0grSun5T5O5QUIS7uiqMLFqgTUQA=";
  };
  buildInputs = [
    CPANMetaCheck
    FileShareDirInstall
    IPCSystemSimple
    PathTiny
    Test2PluginNoWarnings
    Test2Suite
    TestFileShareDir
  ];
  propagatedBuildInputs = [
    FileShareDir
    ParamsValidationCompiler
    Specio
    namespaceautoclean
  ];
  meta = {
    description = "Localization support for DateTime.pm";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
