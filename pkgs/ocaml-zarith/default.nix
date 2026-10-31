{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  ocaml-findlib,
  pkg-config,
  gmp,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-zarith";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "Zarith";
    rev = "release-${version}";
    hash = "sha256-xUrBDr+M8uW2KOy7DZieO/vDgsSOnyBnpOzQDlXJ0oE=";
  };

  nativeBuildInputs = [
    pkg-config
    ocaml
    ocaml-findlib
  ];
  propagatedBuildInputs = [ gmp ];
  strictDeps = true;

  dontAddPrefix = true;
  dontAddStaticConfigureFlags = true;
  configurePlatforms = [ ];
  configureFlags = [ "-installdir ${placeholder "out"}/lib/ocaml/${ocaml.version}/site-lib" ];

  preInstall = "mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib/stublibs";

  meta = {
    description = "Fast, arbitrary precision OCaml integers";
    homepage = "https://github.com/ocaml/Zarith";
    license = lib.licenses.lgpl2;
  };
}
