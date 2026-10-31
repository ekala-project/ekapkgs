{
  buildPerlPackage,
  fetchurl,
  lib,
  FileNext,
}:
buildPerlPackage rec {
  pname = "ack";
  version = "3.10.0";

  src = fetchurl {
    url = "mirror://cpan/authors/id/P/PE/PETDANCE/ack-v${version}.tar.gz";
    hash = "sha256-Zeg8+zinH8pyXpoUqCAe6HHmKfxrECMeEwPdNQG6Vjo=";
  };

  outputs = [
    "out"
    "man"
  ];

  propagatedBuildInputs = [ FileNext ];

  doCheck = false;

  meta = {
    description = "Grep-like tool tailored to working with large trees of source code";
    homepage = "https://beyondgrep.com";
    license = lib.licenses.artistic2;
  };
}
