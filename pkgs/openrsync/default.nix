{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "openrsync";
  version = "0.5.0-unstable-2026-05-31";

  src = fetchFromGitHub {
    owner = "kristapsdz";
    repo = "openrsync";
    rev = "48070e68d73f67d6922b2ffc8c2dee9754e659c6";
    hash = "sha256-9ApkHIak1/XQn1nMwdC0iiZEzZI2gHCOIj8P6bQPFyA=";
  };

  strictDeps = true;
  __structuredAttrs = true;
  enableParallelBuilding = true;

  # Uses oconfigure
  env.prefixKey = "PREFIX=";

  passthru.meta = {
    homepage = "https://www.openrsync.org/";
    description = "BSD-licensed implementation of rsync";
    mainProgram = "openrsync";
    license = lib.licenses.isc;
    maintainers = [ ];
    # https://github.com/kristapsdz/openrsync#portability
    # https://github.com/kristapsdz/oconfigure#readme
    platforms = lib.platforms.unix;
  };
}
