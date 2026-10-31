{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  dune,
  ocaml-findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-re";
  version = "1.12.0";

  src = fetchurl {
    url = "https://github.com/ocaml/ocaml-re/releases/download/${version}/re-${version}.tbz";
    hash = "sha256-oB8r8i9ywvSrq9jT52NeNcG/a8WkGtbVoAdFTdq60dQ=";
  };

  nativeBuildInputs = [
    ocaml
    dune
    ocaml-findlib
  ];

  buildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild
    dune build -p re
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out re
    runHook postInstall
  '';

  meta = {
    broken = true; # dune build failure
    homepage = "https://github.com/ocaml/ocaml-re";
    description = "Pure OCaml regular expressions, with support for Perl and POSIX-style strings";
    license = lib.licenses.lgpl2;
  };
}
