{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
  gitMinimal,
}:

buildGo126Module rec {
  pname = "gitleaks";
  version = "8.30.1";

  src = fetchFromGitHub {
    owner = "gitleaks";
    repo = "gitleaks";
    tag = "v${version}";
    hash = "sha256-l+T0nmsZcFV+OCZZzW6emtGJKsPwAZSPeOi23LkBHRM=";
  };

  vendorHash = "sha256-whJtl34dNltH/dk9qWSThcCYXC0x9PzbAUOO97Int+k=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/zricethezav/gitleaks/v${lib.versions.major version}/version.Version=${version}"
  ];

  subPackages = [
    "."
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  nativeCheckInputs = [ gitMinimal ];

  postInstall = ''
    install -Dm444 config/gitleaks.toml $out/etc/gitleaks.toml
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  meta = {
    description = "Scan git repos (or files) for secrets";
    longDescription = ''
      Gitleaks is a SAST tool for detecting hardcoded secrets like passwords,
      API keys and tokens in git repos.
    '';
    homepage = "https://github.com/gitleaks/gitleaks";
    changelog = "https://github.com/gitleaks/gitleaks/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    mainProgram = "gitleaks";
  };
}
