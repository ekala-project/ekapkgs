{
  lib,
  stdenv,
  fetchFromGitHub,
  ocaml,
  which,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ocamlbuild";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "ocaml";
    repo = "ocamlbuild";
    tag = finalAttrs.version;
    hash = "sha256-RpHVX0o4QduN73j+omlZlycRJaGZWfwHO5kq/WsEGZE=";
  };

  nativeBuildInputs = [
    ocaml
    which
  ];

  buildInputs = [ ocaml ];

  makeFlags = [
    "OCAMLBUILD_PREFIX=$(out)"
    "OCAMLBUILD_BINDIR=$(out)/bin"
    "OCAMLBUILD_LIBDIR=$(out)/lib/ocaml"
    "OCAMLBUILD_MANDIR=$(out)/share/man"
  ];

  buildPhase = ''
    runHook preBuild
    make configure
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install CHECK_IF_PREINSTALLED=false
    runHook postInstall
  '';

  meta = {
    description = "Generic build tool for building OCaml library and programs";
    homepage = "https://github.com/ocaml/ocamlbuild";
    license = lib.licenses.lgpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "ocamlbuild";
  };
})
