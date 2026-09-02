{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  libx11,
  makeWrapper,
  wl-clipboard,
}:

buildGo126Module (finalAttrs: {
  pname = "discordo";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "af65e21854ccb4cb39cafebfd6afbd5f4858a9f0";
    hash = "sha256-0Eiil0gaLlgQRcLIa2XbBF95+pGNGzAIiFRJ7X0r/W0=";
  };

  vendorHash = "sha256-g/kGDK0QKZZAGczrXtVskqpsbES+MZGiuqycJ8YO6DA=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${
        lib.makeBinPath [
          wl-clipboard
        ]
      }
  '';

  meta = {
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = lib.licenses.gpl3Plus;
    mainProgram = "discordo";
  };
})
