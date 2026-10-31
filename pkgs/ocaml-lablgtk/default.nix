{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  ocaml,
  ocaml-findlib,
  pkg-config,
  gtk2,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-lablgtk";
  version = "2.18.13";

  src = fetchFromGitHub {
    owner = "garrigue";
    repo = "lablgtk";
    rev = version;
    sha256 = "sha256-69Svno0qLaUifMscnVuPUJlCo9d8Lee+1qiYx34G3Po=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/garrigue/lablgtk/commit/c9717249954d1713815d435c84f9953a685af4be.patch";
      hash = "sha256-jxmcAIIpdee7sPKfeLAijBnwgKDTjXuiWlh6c9rs+18=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    ocaml
    ocaml-findlib
  ];
  buildInputs = [ gtk2 ];

  configureFlags = [ "--with-libdir=$(out)/lib/ocaml/${ocaml.version}/site-lib" ];
  buildFlags = [ "world" ];

  preInstall = ''
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
    export OCAMLPATH=$out/lib/ocaml/${ocaml.version}/site-lib/:$OCAMLPATH
  '';

  dontStrip = true;

  meta = {
    description = "OCaml interface to GTK";
    homepage = "http://lablgtk.forge.ocamlcore.org/";
    license = lib.licenses.lgpl21Plus;
    mainProgram = "lablgtk2";
  };
}
