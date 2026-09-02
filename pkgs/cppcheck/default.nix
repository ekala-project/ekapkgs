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
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "cppcheck-opensource";
    repo = "cppcheck";
    tag = finalAttrs.version;
    hash = "sha256-kpolGzSk+1lY8EXFciAimhUlv7we3bMbu2/Y0DlO4YU=";
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

  enableParallelBuilding = true;
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
