{
  buildPerlPackage,
  fetchurl,
  lib,
  DevelStackTrace,
}:
buildPerlPackage {
  pname = "Devel-StackTrace-AsHTML";
  version = "0.15";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Devel-StackTrace-AsHTML-0.15.tar.gz";
    hash = "sha256-YoPb4hl+LyAAnMS0SZl3Qhac3ZUb/ETLxuYsKpYtMUc=";
  };
  propagatedBuildInputs = [ DevelStackTrace ];
  meta = {
    description = "Displays stack trace in HTML";
    homepage = "https://github.com/miyagawa/Devel-StackTrace-AsHTML";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
