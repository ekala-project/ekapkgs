{
  buildPerlPackage,
  fetchurl,
  lib,
  commonsense,
}:
buildPerlPackage {
  pname = "Linux-Inotify2";
  version = "2.3";

  src = fetchurl {
    url = "mirror://cpan/authors/id/M/ML/MLEHMANN/Linux-Inotify2-2.3.tar.gz";
    hash = "sha256-y5kVD5/6UdvDvl7pjY6RyYzf6uIuuI5xjyzzZ78nDRc=";
  };

  propagatedBuildInputs = [ commonsense ];

  meta = {
    description = "Scalable directory/file change notification for Perl on Linux";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
