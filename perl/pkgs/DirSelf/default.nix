{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Dir-Self";
  version = "0.11";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MA/MAUKE/Dir-Self-0.11.tar.gz";
    hash = "sha256-4lGlGrx9m6PnCPc8KqII4J1HoMUo1iVHEPp4zI1ohbU=";
  };

  meta = {
    description = "__DIR__ constant for the directory your source file is in";
    homepage = "https://github.com/mauke/Dir-Self";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
