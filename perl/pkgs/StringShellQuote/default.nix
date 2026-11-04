{
  buildPerlPackage,
  fetchurl,
  lib,
  stdenv,
}:
buildPerlPackage {
  pname = "String-ShellQuote";
  version = "1.04";

  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RO/ROSCH/String-ShellQuote-1.04.tar.gz";
    hash = "sha256-5gY2UDjOINZG0lXIBe/90y+GR18Y1DynVFWwDk2G3TU=";
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "Quote strings for passing through the shell";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "shell-quote";
  };
}
