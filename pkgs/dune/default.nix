{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  ocaml-findlib,
}:

stdenv.mkDerivation {
  pname = "dune";
  version = "3.23.1";

  src = fetchurl {
    url = "https://github.com/ocaml/dune/releases/download/3.23.1/dune-3.23.1.tbz";
    hash = "sha256-k7TnFX9rqP62HPxfhgCO/SxZA3unigF9krSr8wYyNI8=";
  };

  nativeBuildInputs = [
    ocaml
    ocaml-findlib
  ];

  strictDeps = true;

  buildFlags = [ "release" ];

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
    "LIBDIR=$(OCAMLFIND_DESTDIR)"
  ];

  meta = {
    homepage = "https://dune.build/";
    description = "Composable build system";
    mainProgram = "dune";
    changelog = "https://github.com/ocaml/dune/raw/3.23.1/CHANGES.md";
    license = lib.licenses.mit;
    platforms = ocaml.meta.platforms or [ ];
  };
}
