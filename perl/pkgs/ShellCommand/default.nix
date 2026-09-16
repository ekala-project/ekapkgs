{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Shell-Command";
  version = "0.06";
  src = fetchurl {
    url = "mirror://cpan/authors/id/F/FL/FLORA/Shell-Command-0.06.tar.gz";
    hash = "sha256-8+Te71d5RL5G+nr1rBGKwoKJEXiLAbx2p0SVNVYW7NE=";
  };
  meta = {
    description = "Cross-platform functions emulating common shell commands";
  };
}
