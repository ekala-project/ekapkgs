{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelGlobalDestruction,
  ParamsValidationCompiler,
  Specio,
  namespaceautoclean,
  IPCRun3,
  TestFatal,
  TestNeeds,
}:
buildPerlPackage {
  pname = "Log-Dispatch";
  version = "2.71";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DR/DROLSKY/Log-Dispatch-2.71.tar.gz";
    hash = "sha256-nWDZZIw1zidUcx603rfwWAns4b1jO3TXR5Wu2exzJXA=";
  };

  propagatedBuildInputs = [
    DevelGlobalDestruction
    ParamsValidationCompiler
    Specio
    namespaceautoclean
  ];

  buildInputs = [
    IPCRun3
    TestFatal
    TestNeeds
  ];

  meta = {
    description = "Dispatches messages to one or more outputs";
    homepage = "https://metacpan.org/release/Log-Dispatch";
    license = lib.licenses.artistic2;
  };
}
