{
  buildPerlPackage,
  fetchurl,
  lib,
}:
buildPerlPackage {
  pname = "MP3-Info";
  version = "1.26";
  src = fetchurl {
    url = "mirror://cpan/authors/id/J/JM/JMERELO/MP3-Info-1.26.tar.gz";
    hash = "sha256-V2I0BzJCHyUCp3DWoSblhPLNljNR0rwle9J4w5vOi+c=";
  };
  meta = {
    description = "Manipulate / fetch info from MP3 audio files";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
