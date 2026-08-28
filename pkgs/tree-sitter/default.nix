{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tree-sitter";
  version = "0.26.13";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "tree-sitter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W+43VmpHihq651eeKoECtxCSQyTGEv9ySMdmPwDFVhM=";
    fetchSubmodules = true;
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  meta = {
    homepage = "https://github.com/tree-sitter/tree-sitter";
    description = "Parser generator tool and an incremental parsing library";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
})
