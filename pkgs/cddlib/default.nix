{
  lib,
  stdenv,
  fetchFromGitHub,
  gmp,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cddlib";
  version = "0.94n";

  src = fetchFromGitHub {
    owner = "cddlib";
    repo = "cddlib";
    rev = finalAttrs.version;
    sha256 = "sha256-j4gXrxsWWiJH5gZc2ZzfYGsBCMJ7G7SQ1xEgurRWZrQ=";
  };

  buildInputs = [ gmp ];
  nativeBuildInputs = [ autoreconfHook ];

  # Disable doc build (requires texlive)
  postPatch = ''
    substituteInPlace Makefile.am \
      --replace-fail "SUBDIRS          = doc lib-src src" "SUBDIRS          = lib-src src"
  '';

  doCheck = true;

  meta = {
    description = "Implementation of the Double Description Method for generating all vertices of a convex polyhedron";
    homepage = "https://www.inf.ethz.ch/personal/fukudak/cdd_home/index.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
