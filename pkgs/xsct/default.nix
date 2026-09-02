{
  stdenv,
  lib,
  fetchFromGitHub,
  libx11,
  libxrandr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xsct";
  version = "2.3";

  src = fetchFromGitHub {
    owner = "faf0";
    repo = "sct";
    tag = finalAttrs.version;
    hash = "sha256-L93Gk7/jcRoUWogWhrOiBvWCCj+EbyGKxBR5oOVjPPU=";
  };

  buildInputs = [
    libx11
    libxrandr
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
  ];
  meta = {
    description = "Set color temperature of screen";
    mainProgram = "xsct";
    homepage = "https://github.com/faf0/sct";
    changelog = "https://github.com/faf0/sct/blob/${finalAttrs.version}/CHANGELOG";
    license = lib.licenses.unlicense;
    platforms = with lib.platforms; linux ++ freebsd ++ openbsd;
  };
})
