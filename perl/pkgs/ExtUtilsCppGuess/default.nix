{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
  CaptureTiny,
  ModuleBuild,
}:
buildPerlPackage {
  pname = "ExtUtils-CppGuess";
  version = "0.26";
  src = fetchurl {
    url = "mirror://cpan/authors/id/E/ET/ETJ/ExtUtils-CppGuess-0.26.tar.gz";
    hash = "sha256-yLNiuGAXKkB2rO4AQ49SuGRk8sUAcCz891J4Ef+aaD4=";
  };
  doCheck = !stdenv.hostPlatform.isDarwin;
  propagatedBuildInputs = [ CaptureTiny ];
  buildInputs = [ ModuleBuild ];
  meta = {
    description = "Guess C++ compiler and flags";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
