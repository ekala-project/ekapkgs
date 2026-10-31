{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  dune,
  ocaml-findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-xml-light";
  version = "2.5";

  src = fetchurl {
    url = "https://github.com/ncannasse/xml-light/releases/download/${version}/xml-light-${version}.tbz";
    hash = "sha256-9YwrPbcK0boICw0wauMvgsy7ldq7ksWZzcRn0eROAD0=";
  };

  nativeBuildInputs = [
    ocaml
    dune
    ocaml-findlib
  ];

  buildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild
    dune build -p xml-light
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out xml-light
    runHook postInstall
  '';

  meta = {
    description = "Minimal Xml parser and printer for OCaml";
    homepage = "https://github.com/ncannasse/xml-light";
    license = lib.licenses.lgpl21;
  };
}
