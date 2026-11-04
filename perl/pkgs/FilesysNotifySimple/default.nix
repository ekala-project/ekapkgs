{
  buildPerlPackage,
  fetchurl,
  lib,
  TestSharedFork,
}:
buildPerlPackage {
  pname = "Filesys-Notify-Simple";
  version = "0.14";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MI/MIYAGAWA/Filesys-Notify-Simple-0.14.tar.gz";
    hash = "sha256-H9pxLUul4YaBWe019vjvv66dQ11jdvVgbVM7ywgFVaQ=";
  };
  buildInputs = [ TestSharedFork ];
  meta = {
    description = "Simple and dumb file system watcher";
    homepage = "https://github.com/miyagawa/Filesys-Notify-Simple";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
