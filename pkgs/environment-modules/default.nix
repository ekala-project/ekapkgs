{
  lib,
  stdenv,
  fetchFromGitHub,
  tcl,
  python3,
  procps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "environment-modules";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "cea-hpc";
    repo = "modules";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FRSr90HyJiZW3M4AuDWOcSzpvG7p9HnaQiSnK1Rlg0c=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    procps
  ];

  buildInputs = [
    tcl
    python3
  ];

  configureFlags = [
    "--with-tclsh=${tcl}/bin/tclsh"
    "--with-python=${python3}/bin/python3"
    "--with-bin-search-path=${procps}/bin:/usr/bin:/bin:/usr/local/bin"
  ];

  meta = {
    description = "Environment Modules for managing shell environment";
    homepage = "https://modules.readthedocs.io/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "modulecmd";
  };
})
