{
  buildPerlPackage,
  fetchurl,
  lib,
  FileShareDir,
  Readonly,
}:
buildPerlPackage {
  pname = "File-Share";
  version = "0.27";
  src = fetchurl {
    url = "mirror://cpan/authors/id/I/IN/INGY/File-Share-0.27.tar.gz";
    hash = "sha256-1uj0tV69OOC7ReRDkuP6J9wf3harxdH/U+FX4ZpXVb4=";
  };
  propagatedBuildInputs = [
    FileShareDir
    Readonly
  ];
  meta = {
    description = "Extend File::ShareDir to Local Libraries";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
