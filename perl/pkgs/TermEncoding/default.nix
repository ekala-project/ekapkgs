{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Term-Encoding";
  version = "0.03";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Term-Encoding-0.03.tar.gz";
    hash = "sha256-lbqWh9c10lo8vmRQjXiU8AnH+ioXJsPnhuniHaIlHQs=";
  };

  meta = {
    description = "Detect encoding of the current terminal";
    homepage = "https://github.com/miyagawa/Term-Encoding";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
