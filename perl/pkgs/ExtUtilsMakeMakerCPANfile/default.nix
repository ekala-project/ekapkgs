{
  buildPerlPackage,
  fetchurl,
  lib,
  ModuleCPANfile,
}:
buildPerlPackage {
  pname = "ExtUtils-MakeMaker-CPANfile";
  version = "0.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IS/ISHIGAKI/ExtUtils-MakeMaker-CPANfile-0.09.tar.gz";
    hash = "sha256-LAd2B9SwoQhWkHTf926BaGWQYq2jpq94swzKDUD44nU=";
  };
  propagatedBuildInputs = [ ModuleCPANfile ];
  meta = {
    description = "Cpanfile support for EUMM";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
