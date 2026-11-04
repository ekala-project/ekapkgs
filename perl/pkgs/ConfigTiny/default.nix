{
  buildPerlPackage,
  fetchurl,
  lib,
  TestPod,
}:
buildPerlPackage {

  pname = "Config-Tiny";
  version = "2.29";
  src = fetchurl {
    url = "mirror://cpan/authors/id/R/RS/RSAVAGE/Config-Tiny-2.29.tgz";
    hash = "sha256-PeebDqA6jWqT6dkSj+hF+1ViIrFGmaT28NXKBXrjMzs=";
  };
  buildInputs = [ TestPod ];
  meta = {
    description = "Read/Write .ini style files with as little code as possible";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
