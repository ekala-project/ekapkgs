{ buildPerlPackage, fetchurl }:
buildPerlPackage {
  pname = "Test-More-UTF8";
  version = "0.05";
  src = fetchurl {
    url = "mirror://cpan/authors/id/M/MO/MONS/Test-More-UTF8-0.05.tar.gz";
    hash = "sha256-ufHEs2qXzf76pT7REV3Tj0tIMDd3X2VZ7h3xSs/RzgQ=";
  };
  meta = {
    description = "Enhancing Test::More for UTF8-based projects";
  };
}
