{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPackages,
  callPackage,
}:

let
  mecab-nodic = callPackage ./nodic.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mecab-ipadic";
  version = "2.7.0-20070801";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "mecab";
    rev = "2fd29256c6d5e1b10211cac838069ee9ede8c77a";
    hash = "sha256-zsTAs+nOmQ8G3QjU57upbBuDxKFIZGqD8X0uLW44W5M=";
    rootDir = "mecab-ipadic";
  };

  sourceRoot = "${finalAttrs.src.name}/mecab-ipadic";

  buildInputs = [ mecab-nodic ];

  configureFlags = [
    "--with-charset=utf8"
    "--with-dicdir=${placeholder "out"}"
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--with-mecab-config=${lib.getExe' buildPackages.mecab "mecab-config"}"
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "--with-mecab-config=${lib.getExe' (lib.getDev mecab-nodic) "mecab-config"}"
  ];
})
