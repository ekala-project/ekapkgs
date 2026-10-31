{
  buildPerlPackage,
  fetchurl,
  lib,
  EmailSimple,
  MROCompat,
  ModulePluggable,
}:
buildPerlPackage {
  pname = "Email-Abstract";
  version = "3.010";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RJ/RJBS/Email-Abstract-3.010.tar.gz";
    hash = "sha256-jBL2i1l0yvyZ10lCq+/IWXGTA1qv0nYxKOaqr8pLftY=";
  };
  propagatedBuildInputs = [
    EmailSimple
    MROCompat
    ModulePluggable
  ];
  meta = {
    description = "Unified interface to mail representations";
    homepage = "https://github.com/rjbs/Email-Abstract";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
