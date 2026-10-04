{
  lib,
  stdenv,
  fetchFromGitHub,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bcal";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "jarun";
    repo = "bcal";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Jub6nzol5Wmt/B8U5jmuyTHEKnsg3N28zDjWn/wRhOY=";
  };

  buildInputs = [ readline ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Storage conversion and expression calculator";
    homepage = "https://github.com/jarun/bcal";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "bcal";
  };
})
