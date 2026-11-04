{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Encode";
  version = "3.19";

  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DA/DANKOGAI/Encode-3.19.tar.gz";
    hash = "sha256-kWP4SO72nk1MyIODl/CGH9nqft4AERfb2WlPjZUFLvU=";
  };

  meta = {
    description = "Character encodings in Perl";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
    mainProgram = "piconv";
  };
}
