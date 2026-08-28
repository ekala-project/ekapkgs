{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  ncurses,
  installShellFiles,
  asciidoctor,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rink";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tiffany352";
    repo = "rink-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JRXRN/jOwM3j59ckOcIlbLdSvV9PFueOPs/EVHCF8JE=";
  };

  cargoHash = "sha256-qbMnJjJQbNqs6AAgMjtqPEMxIDxdF5a8/tWAVW0Vrig=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
    asciidoctor
  ];

  buildInputs = [
    ncurses
    openssl
  ];

  doCheck = false;

  postBuild = ''
    make man
  '';

  postInstall = ''
    installManPage build/*
  '';

  meta = {
    description = "Unit-aware calculator";
    mainProgram = "rink";
    homepage = "https://rinkcalc.app";
    license = with lib.licenses; [
      mpl20
      gpl3Plus
    ];
  };
})
