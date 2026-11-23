{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbsdgames";
  version = "6";

  src = fetchFromGitHub {
    owner = "abakh";
    repo = "nbsdgames";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m7mrOq43v5st8TwnqbxnVZMH2mmkyDgIRfCnISvj/U8=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ ncurses ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "GAMES_DIR=bin"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = {
    description = "Package of 18 text-based modern games";
    homepage = "https://github.com/abakh/nbsdgames";
    license = lib.licenses.cc0;
    mainProgram = "nbsdgames";
    platforms = lib.platforms.all;
  };
})
