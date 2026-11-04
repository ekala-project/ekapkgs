{
  buildPerlPackage,
  fetchurl,
  lib,
  ClassTiny,
  FileShareDir,
  FileShareDirInstall,
  LinguaENInflect,
  PathTiny,
  PodParser,
  TestDeep,
}:
buildPerlPackage {
  pname = "Pod-Spell";
  version = "1.26";

  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HAARG/Pod-Spell-1.26.tar.gz";
    hash = "sha256-LwW/yc+wS5b8v6LIVE0eaukIWW02lsRuDiZVa3UK+78=";
  };

  propagatedBuildInputs = [
    ClassTiny
    FileShareDir
    LinguaENInflect
    PathTiny
    PodParser
  ];

  buildInputs = [
    FileShareDirInstall
    TestDeep
  ];

  meta = {
    description = "Formatter for spellchecking Pod";
    homepage = "https://github.com/perl-pod/Pod-Spell";
    license = lib.licenses.artistic2;
    mainProgram = "podspell";
  };
}
