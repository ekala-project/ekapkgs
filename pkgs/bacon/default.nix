{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  alsa-lib,
  buildPackages,
  withSound ? false,
}:

let
  soundDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bacon";
  version = "3.24.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Canop";
    repo = "bacon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rfbK5MrCytBVISXVkazBDnZZxjZQ3ze348mlTyanTWM=";
  };

  cargoHash = "sha256-s49qZMD922l6KKSFRhVIGp6+7E0S+q7McV9PT2F0RQc=";

  buildFeatures = lib.optionals withSound [
    "sound"
  ];

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals withSound [
    pkg-config
  ];

  buildInputs = lib.optionals withSound soundDependencies;

  postInstall =
    let
      bacon = "${stdenv.hostPlatform.emulator buildPackages} $out/bin/bacon";
    in
    lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) ''
      installShellCompletion --cmd bacon \
        --bash <(COMPLETE=bash ${bacon}) \
        --fish <(COMPLETE=fish ${bacon}) \
        --zsh <(COMPLETE=zsh ${bacon})
    '';

  meta = {
    description = "Background rust code checker";
    mainProgram = "bacon";
    homepage = "https://github.com/Canop/bacon";
    changelog = "https://github.com/Canop/bacon/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
  };
})
