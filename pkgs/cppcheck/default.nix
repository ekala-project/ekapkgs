{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  pcre,
  python3,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cppcheck";
  version = "2.22.0";

  src = fetchFromGitHub {
    owner = "cppcheck-opensource";
    repo = "cppcheck";
    tag = finalAttrs.version;
    hash = "sha256-HbrNBDxo3/b4h6BeBD9gohI4PB4xeosy9Y0Y3uB4J2g=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
    which
  ];

  buildInputs = [
    pcre
    (python3.withPackages (ps: [ ps.pygments ]))
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "MATCHCOMPILER=yes"
    "FILESDIR=$(out)/share/cppcheck"
    "HAVE_RULES=yes"
  ];

  strictDeps = true;

  doCheck = false;

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'PCRE_CONFIG = $(shell which pcre-config)' 'PCRE_CONFIG = $(PKG_CONFIG) libpcre'
  '';

  meta = {
    description = "Static analysis tool for C/C++ code";
    homepage = "http://cppcheck.sourceforge.net";
    license = lib.licenses.gpl3Plus;
    mainProgram = "cppcheck";
    platforms = lib.platforms.unix;
  };
})
