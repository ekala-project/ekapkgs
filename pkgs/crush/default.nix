{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  testers,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "crush";
  version = "0.97.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "crush";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2VNA31Wn67lpDI2lE6U1uczWfruI66HFkzBtYlm9J1M=";
  };

  vendorHash = "sha256-kGvyIpS+ZrwfOl0j1Wj/tnMEiCB6zdll0vql+35jSg4=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  # Tests require config files that aren't available in the build environment.
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/charmbracelet/crush/internal/version.Version=${finalAttrs.version}"
  ];

  postInstall = ''
    installShellCompletion --cmd crush \
      --bash <($out/bin/crush completion bash) \
      --fish <($out/bin/crush completion fish) \
      --zsh <($out/bin/crush completion zsh)

    install -Dm644 schema.json $out/share/crush/schema.json
  '';

  passthru = {
    jsonschema = "${placeholder "out"}/share/crush/schema.json";
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = finalAttrs.version;
    };
  };

  meta = {
    description = "Glamourous AI coding agent for your favourite terminal";
    homepage = "https://github.com/charmbracelet/crush";
    changelog = "https://github.com/charmbracelet/crush/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "crush";
    platforms = lib.platforms.unix;
  };
})
