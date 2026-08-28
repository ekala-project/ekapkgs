{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jo";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "jpmens";
    repo = "jo";
    tag = finalAttrs.version;
    sha256 = "sha256-1q4/RpxfoAdtY3m8bBuj7bhD17V+4dYo3Vb8zMbI1YU=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # pandoc is not available; the pre-built jo.1 is shipped in the tarball
  # so the build works without pandoc as long as we don't try to rebuild it

  meta = {
    description = "Small utility to create JSON objects";
    homepage = "https://github.com/jpmens/jo";
    mainProgram = "jo";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
})
