{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  dune,
  ocaml-findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-fileutils";
  version = "0.6.6";

  src = fetchurl {
    url = "https://github.com/gildor478/ocaml-fileutils/releases/download/v${version}/fileutils-${version}.tbz";
    hash = "sha256-eW1XkeK/ezv/IAz1BXp6GHhDnrzXTtDxCIz4Z1bVK+Y=";
  };

  nativeBuildInputs = [
    ocaml
    dune
    ocaml-findlib
  ];

  buildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild
    dune build -p fileutils
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out fileutils
    runHook postInstall
  '';

  meta = {
    description = "OCaml API to manipulate real files (POSIX like) and filenames";
    homepage = "https://github.com/gildor478/ocaml-fileutils";
    license = lib.licenses.lgpl21Plus;
  };
}
