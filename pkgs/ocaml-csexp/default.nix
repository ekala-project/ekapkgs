{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  dune,
  ocaml-findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-csexp";
  version = "1.5.2";

  src = fetchurl {
    url = "https://github.com/ocaml-dune/csexp/releases/download/${version}/csexp-${version}.tbz";
    hash = "sha256-GhTdBLtDeaQZkCSFUGKMd5E6nAfzw1wTcLaWDml3h/8=";
  };

  nativeBuildInputs = [
    ocaml
    dune
    ocaml-findlib
  ];

  buildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild
    dune build -p csexp
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out csexp
    runHook postInstall
  '';

  meta = {
    description = "Minimal support for Canonical S-expressions";
    homepage = "https://github.com/ocaml-dune/csexp";
    license = lib.licenses.mit;
  };
}
