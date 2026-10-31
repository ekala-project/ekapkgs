{
  buildPerlPackage,
  fetchurl,
  lib,
  aspell,
}:
buildPerlPackage {
  pname = "Text-Aspell";
  version = "0.09";
  src = fetchurl {
    url = "mirror://cpan/authors/id/H/HA/HANK/Text-Aspell-0.09.tar.gz";
    hash = "sha256-K+oyCfGOJzsZPjF1pC0mk5GRnkmrEGtuJSOV0nIYL2U=";
  };
  propagatedBuildInputs = [ aspell ];
  env.NIX_CFLAGS_COMPILE = "-I${aspell}/include";
  env.NIX_CFLAGS_LINK = "-L${aspell}/lib -laspell";
  meta = {
    description = "Perl interface to the GNU Aspell library";
    license = with lib.licenses; [
      artistic1
      gpl1Plus
    ];
  };
}
