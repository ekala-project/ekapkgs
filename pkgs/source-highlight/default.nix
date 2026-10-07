{
  lib,
  stdenv,
  fetchurl,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "source-highlight";
  version = "3.1.9";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnu/src-highlite/source-highlight-${version}.tar.gz";
    hash = "sha256-vamMBNdOFpHl0W7hzpN+GEsLlMTj4YlBMDkuR+elJOw=";
  };

  buildInputs = [ boost ];

  configureFlags = [
    "--with-boost=${boost.out}"
    "--with-bash-completion=${placeholder "out"}/share/bash-completion/completions"
  ];

  doCheck = false;


  meta = {
    description = "Source code renderer with syntax highlighting";
    homepage = "https://www.gnu.org/software/src-highlite/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
