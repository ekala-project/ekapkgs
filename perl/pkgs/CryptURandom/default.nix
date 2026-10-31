{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "Crypt-URandom";
  version = "0.55";
  src = fetchurl {
    url = "mirror://cpan/authors/id/D/DD/DDICK/Crypt-URandom-0.55.tar.gz";
    hash = "sha256-759EFBBzwTVz6FsUj/mpCJxFglt9ZgjYMuQmOJnTotQ=";
  };
  meta = {
    description = "Provide non blocking randomness";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
