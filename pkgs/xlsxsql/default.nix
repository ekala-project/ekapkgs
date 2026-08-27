{
  lib,
  buildGo126Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo126Module (finalAttrs: {
  pname = "xlsxsql";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "noborus";
    repo = "xlsxsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-07Gnw1Y8TyxoOMMevnx4tGyk6k7n4o3gDaOPshsmcSE=";
  };

  vendorHash = "sha256-3r7KY6boNYd2tJjMExiTZD1ZxQhm2UlP/Gyic8XMGrw=";

  ldflags = [
    "-X main.version=v${finalAttrs.version}"
    "-X main.revision=${finalAttrs.src.rev}"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd xlsxsql \
      --bash <($out/bin/xlsxsql completion bash) \
      --fish <($out/bin/xlsxsql completion fish) \
      --zsh <($out/bin/xlsxsql completion zsh)
  '';

  doCheck = false;

  meta = {
    description = "CLI tool that executes SQL queries on various files including xlsx files";
    homepage = "https://github.com/noborus/xlsxsql";
    changelog = "https://github.com/noborus/xlsxsql/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "xlsxsql";
  };
})
