{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "File-ReadBackwards";
  version = "1.06";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PL/PLICEASE/File-ReadBackwards-1.06.tar.gz";
    hash = "sha256-MrKgVJOJqviIde8D1+u//y1ZeeyoW3yBL2tLsQ0QL2I=";
  };

  meta = {
    description = "Read a file backwards by lines";
    homepage = "https://metacpan.org/pod/File::ReadBackwards";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
