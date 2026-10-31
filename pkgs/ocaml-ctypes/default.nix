{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  dune,
  ocaml-findlib,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-ctypes";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "yallop";
    repo = "ocaml-ctypes";
    rev = version;
    hash = "sha256-Wlpk+/MSWmnIRsJfVQMTCYDRixuqLzDpdFNpkQyscA8=";
  };

  nativeBuildInputs = [
    ocaml
    dune
    ocaml-findlib
  ];

  buildInputs = [ ocaml ];

  buildPhase = ''
    runHook preBuild
    dune build -p ctypes,ctypes-foreign
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install --prefix $out ctypes ctypes-foreign
    runHook postInstall
  '';

  meta = {
    broken = true; # dune build failure
    homepage = "https://github.com/yallop/ocaml-ctypes";
    description = "Library for binding to C libraries using pure OCaml";
    license = lib.licenses.mit;
  };
}
