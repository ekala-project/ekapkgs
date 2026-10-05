{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeWrapper,
  bash,
  coreutils,
  gawk,
  gitMinimal,
  gnutar,
  openssh,
  procps,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  hashes = builtins.fromJSON (builtins.readFile ./hashes.json);
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openresearch";
  inherit (hashes) version cargoHash;

  src = fetchFromGitHub {
    owner = "alphaXiv";
    repo = "OpenResearch";
    tag = "v${finalAttrs.version}";
    inherit (hashes) hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace $(grep -rl '#!/bin/sh' src) \
      --replace-fail '#!/bin/sh' '#!${bash}/bin/sh'
    substituteInPlace src/commands/up.rs \
      --replace-fail '"sh",' '"${bash}/bin/sh",'
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  dontUseCargoParallelTests = true; # ETXTBSY: tests write+exec scripts

  nativeCheckInputs = [
    bash
    coreutils
    gawk
    gitMinimal
    gnutar
    openssh
    procps
  ];

  postInstall = ''
    wrapProgram $out/bin/orx \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            bash
            coreutils
            gitMinimal
            gnutar
            openssh
            procps
            # TODO(corepkgs): add xdg-utils for opening URLs
          ]
        )
      } \
      --set OPENRESEARCH_CLI_DISABLE_UPDATE 1 \
      --set ORX_NO_UPDATE_CHECK 1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    version = finalAttrs.version;
  };

  meta = {
    description = "Local-first workspace for research agents and autoresearch";
    homepage = "https://openresearch.sh/";
    changelog = "https://github.com/alphaXiv/OpenResearch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "orx";
    platforms = lib.platforms.unix;
  };
})
