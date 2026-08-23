{
  lib,
  stdenv,
  buildGo126Module,
  installShellFiles,
  fetchFromGitHub,
}:

buildGo126Module (finalAttrs: {
  pname = "mods";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "mods";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CT90uMQc0quQK/vCeLiHH8taEkCSDIcO7Q3aA+oaNmY=";
  };

  vendorHash = "sha256-jtSuSKy6GpWrJAXVN2Acmtj8klIQrgJjNwgyRZIyqyY=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  # These tests require internet access.
  checkFlags = [ "-skip=^TestLoad/http_url$|^TestLoad/https_url$" ];

  postInstall = ''
    export HOME=$(mktemp -d)
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/mods man > ./mods.1
    installManPage ./mods.1
    installShellCompletion --cmd mods \
      --bash <($out/bin/mods completion bash) \
      --fish <($out/bin/mods completion fish) \
      --zsh <($out/bin/mods completion zsh)
  '';

  meta = {
    description = "AI on the command line";
    homepage = "https://github.com/charmbracelet/mods";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "mods";
  };
})
