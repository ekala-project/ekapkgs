{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "endlessh";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "skeeto";
    repo = "endlessh";
    rev = finalAttrs.version;
    hash = "sha256-yHQzDrjZycDL/2oSQCJjxbZQJ30FoixVG1dnFyTKPH4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "SSH tarpit that slowly sends an endless banner";
    homepage = "https://github.com/skeeto/endlessh";
    changelog = "https://github.com/skeeto/endlessh/releases/tag/${finalAttrs.version}";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    mainProgram = "endlessh";
  };
})
