{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tinyssh";
  version = "20261101";

  src = fetchFromGitHub {
    owner = "janmojzis";
    repo = "tinyssh";
    tag = finalAttrs.version;
    hash = "sha256-srsuaJ6dzLGseENI+u4B+c5uLbrwgW+v6DSVCojhxUU=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=implicit-function-declaration";

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    description = "Minimalistic SSH server";
    homepage = "https://tinyssh.org";
    changelog = "https://github.com/janmojzis/tinyssh/releases/tag/${finalAttrs.version}";
    license = lib.licenses.cc0;
    platforms = lib.platforms.unix;
  };
})
