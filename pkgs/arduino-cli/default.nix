{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  buildFHSEnv,
  installShellFiles,
  makeWrapper,
  python3,
  zlib,
}:

let
  pkg = buildGo126Module (finalAttrs: {
    pname = "arduino-cli";
    version = "1.5.1";

    src = fetchFromGitHub {
      owner = "arduino";
      repo = "arduino-cli";
      tag = "v${finalAttrs.version}";
      hash = "sha256-MZX6ERZwmfiJMqx6mQ0qAfv1dbXunTYHRbdzyoinOJY=";
    };

    nativeBuildInputs = [
      installShellFiles
      makeWrapper
    ];

    subPackages = [ "." ];

    vendorHash = "sha256-j5SpZnBWcC8K8lHgc5HOCbGD3DdHr9tVtEhXWTCCogk=";

    doCheck = false;

    ldflags = [
      "-s"
      "-w"
      "-X github.com/arduino/arduino-cli/internal/version.versionString=${finalAttrs.version}"
      "-X github.com/arduino/arduino-cli/internal/version.commit=unknown"
      "-extldflags '-static'"
    ];

    postInstall = ''
      wrapProgram $out/bin/arduino-cli --prefix PATH : ${lib.makeBinPath [ python3 ]}
      export HOME=$(mktemp -d)
      installShellCompletion --cmd arduino-cli \
        --bash <($out/bin/arduino-cli completion bash) \
        --zsh <($out/bin/arduino-cli completion zsh) \
        --fish <($out/bin/arduino-cli completion fish)
    '';

    meta = {
      inherit (finalAttrs.src.meta) homepage;
      description = "Arduino from the command line";
      mainProgram = "arduino-cli";
      changelog = "https://github.com/arduino/arduino-cli/releases/tag/${finalAttrs.src.tag}";
      license = with lib.licenses; [
        gpl3Only
        asl20
      ];
      maintainers = [ ];
    };
  });
in
buildFHSEnv {
  inherit (pkg) pname version meta;

  runScript = "${pkg.outPath}/bin/arduino-cli";

  extraInstallCommands = ''
    cp -r ${pkg.outPath}/share $out/share
  '';

  targetPkgs = pkgs: with pkgs; [ zlib ];
}
