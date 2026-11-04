{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "X11-Protocol";
  version = "0.56";

  src = fetchurl {
    url = "mirror://cpan/authors/id/S/SM/SMCCAM/X11-Protocol-0.56.tar.gz";
    hash = "sha256-3pbdbHwfJfMoeqevZJAr+ErKqo4MO7dqoWdjZ+BKCLc=";
  };

  meta = {
    description = "Perl module for the X Window System Protocol, version 11";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
